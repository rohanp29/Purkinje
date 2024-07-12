//
//  ProximityManager.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/12/24.
//

// ProximityManager.swift
import Foundation
import NearbyInteraction
import MultipeerConnectivity

class ProximityManager: NSObject, ObservableObject, NISessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    private var niSession: NISession?
    private var peerDiscoveryToken: NIDiscoveryToken?
    private var myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var mcSession: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    @Published var isNearby = false

    override init() {
        super.init()
        niSession = NISession()
        niSession?.delegate = self

        mcSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self

        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: "skill-drop")
        advertiser?.delegate = self

        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: "skill-drop")
        browser?.delegate = self

        advertiser?.startAdvertisingPeer()
        browser?.startBrowsingForPeers()
    }

    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let nearbyObject = nearbyObjects.first, let distance = nearbyObject.distance else {
            print("No nearby objects or distance data.")
            return
        }
        print("Detected distance: \(distance)")
        isNearby = distance < 0.1 // Example condition
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        print("Session invalidated: \(error.localizedDescription)")
    }

    // MARK: - MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Advertiser did not start advertising peer: \(error.localizedDescription)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from peer: \(peerID.displayName)")
        invitationHandler(true, mcSession)
    }

    // MARK: - MCNearbyServiceBrowserDelegate

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Browser did not start browsing for peers: \(error.localizedDescription)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: mcSession!, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
    }

    // MARK: - MCSessionDelegate

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to peer: \(peerID.displayName)")
            exchangeDiscoveryToken() // Exchange discovery tokens when connected
        case .connecting:
            print("Connecting to peer: \(peerID.displayName)")
        case .notConnected:
            print("Not connected to peer: \(peerID.displayName)")
        @unknown default:
            fatalError("Unknown state: \(state)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Did receive data from peer: \(peerID.displayName)")
        handleReceivedData(data)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Handle received stream if needed
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Handle resource start if needed
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Handle resource finish if needed
    }

    private func exchangeDiscoveryToken() {
        guard let discoveryToken = niSession?.discoveryToken else {
            print("Failed to get discovery token.")
            return
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: discoveryToken, requiringSecureCoding: true)
            try mcSession?.send(data, toPeers: mcSession!.connectedPeers, with: .reliable)
            print("Sent discovery token.")
        } catch {
            print("Failed to send discovery token: \(error.localizedDescription)")
        }
    }

    private func handleReceivedData(_ data: Data) {
        do {
            if let discoveryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) {
                let config = NINearbyPeerConfiguration(peerToken: discoveryToken)
                niSession?.run(config)
                print("Configured nearby interaction session with received discovery token.")
            }
        } catch {
            print("Failed to decode discovery token: \(error.localizedDescription)")
        }
    }
}
