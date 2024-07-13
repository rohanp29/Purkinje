//
//  PhysicianListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/12/24.
//

import SwiftUI
import FirebaseAuth

struct PhysicianListView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contentViewModel: ContentViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var mpcSession: MPCSession?
    
    var body: some View {
        NavigationView {
            VStack {
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
        // Placeholder for incrementing skill count on the trainee's phone
        print("Incrementing skill count for \(skill.skilltype)")
    }
    
    func startGrantCredentialSession() {
        // Placeholder for starting a session using Nearby Interaction framework
        print("Initiating credential granting")
        mpcSession = MPCSession(service: "skilldrop", identity: "attending", maxPeers: 1)
        mpcSession?.start()
    }
}

struct PhysicianListView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicianListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
