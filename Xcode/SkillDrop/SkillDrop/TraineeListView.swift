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
    
    var body: some View {
        NavigationView {
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
}

struct TraineeListView_Previews: PreviewProvider {
    static var previews: some View {
        TraineeListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
