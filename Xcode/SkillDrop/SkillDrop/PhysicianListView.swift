//
//  PhysicianListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/12/24.
//

import SwiftUI
import FirebaseAuth
import NearbyInteraction

struct PhysicianListView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contentViewModel: ContentViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var mpcSession: MPCSession?
    @State private var niManager = NearbyInteractionManager()
    @State private var isConnected = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                // Connection Status Label
                Text(isConnected ? "Connection is established" : "Connection not established")
                    .foregroundColor(isConnected ? .green : .red)
                    .padding()

                Button(action: {
                    startGrantCredentialSession()
                }) {
                    Text("Grant Credential")
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
                        
                        Button(action: {
                            incrementSkill(skill)
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                .navigationTitle("Skills")
                .navigationBarItems(trailing: logoutButton)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Connection Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
    
    func incrementSkill(_ skill: Skill) {
        if isConnected {
            print("Attempting to increment skill: \(skill.skilltype) with ID: \(skill.id)")
            dataManager.incrementSkillCount(skillID: skill.id)
        } else {
            print("No connection established. Cannot increment skill.")
            alertMessage = "No connection established with the trainee. Cannot increment skill."
            showAlert = true
        }
    }
    
    func startGrantCredentialSession() {
        // Start the Nearby Interaction session
        niManager = NearbyInteractionManager()
        guard let myToken = niManager.niSession?.discoveryToken else {
            fatalError("Unable to get self discovery token, is this session invalidated?")
        }
        
        // Set up Multipeer Connectivity
        mpcSession = MPCSession(service: "skilldrop", identity: "attending", maxPeers: 1)
        mpcSession?.peerConnectedHandler = { peerID in
            print("Connected to peer: \(peerID.displayName)")
            self.isConnected = true
            // Send discovery token to the peer
            self.sendDiscoveryToken(myToken)
        }
        mpcSession?.peerDisconnectedHandler = { peerID in
            print("Disconnected from peer: \(peerID.displayName)")
            self.isConnected = false
        }
        mpcSession?.peerDataHandler = { data, peerID in
            // Receive discovery token from the peer
            print("Receiving discovery token from peer: \(peerID.displayName)")
            self.receiveDiscoveryToken(data)
        }
        mpcSession?.start()
        
        print("Initiating credential granting")
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

struct PhysicianListView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicianListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
