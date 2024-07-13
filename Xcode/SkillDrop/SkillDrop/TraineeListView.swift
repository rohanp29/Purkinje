//
//  TraineeListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/12/24.
//

import SwiftUI
import FirebaseAuth

struct TraineeListView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contentViewModel: ContentViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var mpcSession: MPCSession?
    
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
        // Placeholder for starting a session using Nearby Interaction framework
        print("Initiating credential receiving")
        mpcSession = MPCSession(service: "skilldrop", identity: "trainee", maxPeers: 1)
        mpcSession?.start()
    }
}

struct TraineeListView_Previews: PreviewProvider {
    static var previews: some View {
        TraineeListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
