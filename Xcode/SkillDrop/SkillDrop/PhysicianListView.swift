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
    
    var body: some View {
        NavigationView {
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
        // Implement the logic to increment skill count on the trainee's phone
        // For now, this can be a placeholder function
        print("Incrementing skill count for \(skill.skilltype)")
    }
}

struct PhysicianListView_Previews: PreviewProvider {
    static var previews: some View {
        PhysicianListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}

