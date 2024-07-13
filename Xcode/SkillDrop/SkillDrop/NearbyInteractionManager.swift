//
//  NearbyInteractionManager.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/13/24.
//

import Foundation
import NearbyInteraction

class NearbyInteractionManager: NSObject, NISessionDelegate {
    var niSession: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    
    override init() {
        super.init()
        niSession = NISession()
        niSession?.delegate = self
    }
    
    func startSession(with peerToken: NIDiscoveryToken) {
        peerDiscoveryToken = peerToken
        let config = NINearbyPeerConfiguration(peerToken: peerToken)
        niSession?.run(config)
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        // Handle updates from the Nearby Interaction session
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        // Handle session invalidation
    }
}
