//
//  TraineeListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/12/24.
//

import SwiftUI
import FirebaseAuth
import NearbyInteraction

struct TraineeListView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contentViewModel: ContentViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var mpcSession: MPCSession?
    @State private var niManager = NearbyInteractionManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    startReceiveCredentialSession()
                }) {
                    Text("Receive Credential")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                        .padding()
                }
                
                List(dataManager.skills, id: \.id) { skill in
                    HStack {
                        Text(skill.skilltype)
                        Spacer()
                        Text("\(skill.count)")
                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("Skills")
                .navigationBarItems(trailing: logoutButton)
            }
        }
    }
    
    var logoutButton: some View {
        Button(action: {
            logout()
        }) {
            Text("Logout")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            contentViewModel.userIsLoggedIn = false
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func startReceiveCredentialSession() {
        // Start the Nearby Interaction session
        niManager = NearbyInteractionManager()
        guard let myToken = niManager.niSession?.discoveryToken else {
            fatalError("Unable to get self discovery token, is this session invalidated?")
        }
        
        // Set up Multipeer Connectivity
        mpcSession = MPCSession(service: "skilldrop", identity: "trainee", maxPeers: 1)
        mpcSession?.peerConnectedHandler = { peerID in
            // Send discovery token to the peer
            print("Sending discovery token to peer: \(peerID.displayName)")
            self.sendDiscoveryToken(myToken)
        }
        mpcSession?.peerDataHandler = { data, peerID in
            // Receive discovery token from the peer
            print("Receiving discovery token from peer: \(peerID.displayName)")
            self.receiveDiscoveryToken(data)
        }
        mpcSession?.start()
        
        print("Initiating credential receiving")
    }
    
    func sendDiscoveryToken(_ token: NIDiscoveryToken) {
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        print("Sending discovery token")
        mpcSession?.sendDataToAllPeers(data: encodedData)
    }
    
    func receiveDiscoveryToken(_ data: Data) {
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        print("Received discovery token")
        niManager.startSession(with: discoveryToken)
    }
}

struct TraineeListView_Previews: PreviewProvider {
    static var previews: some View {
        TraineeListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
