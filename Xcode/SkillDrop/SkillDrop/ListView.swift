//
//  ListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

import SwiftUI
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    
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
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    logout()
                //add
                }, label: {
                    Text("Logout")
                })
                Button(action: {
                    //add new skill action
                }, label: {
                    Image(systemName: "plus")
                })
            })
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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
