//
//  ListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

// ListView.swift
import SwiftUI
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var contentViewModel: ContentViewModel
    @Binding var selectedSkillId: String?
    @StateObject private var proximityManager = ProximityManager() //CHANGES
    
    var body: some View {
        NavigationView {
            VStack {
                Text(proximityManager.isNearby ? "Nearby Device Detected" : "No Device Nearby") //CHANGES
                    .foregroundColor(proximityManager.isNearby ? .green : .red) //CHANGES
                    .padding() //CHANGES
                
                List(dataManager.skills, id: \.id) { skill in
                    HStack {
                        Text(skill.skilltype)
                        Spacer()
                        Text("\(skill.count)")
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedSkillId = skill.id
                    }
                }
                .navigationTitle("Skills")
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        logout()
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
        .onChange(of: proximityManager.isNearby) { //CHANGES
            if proximityManager.isNearby, let skillId = selectedSkillId { //CHANGES
                dataManager.incrementSkillCount(skillId: skillId) //CHANGES
            } //CHANGES
        } //CHANGES
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
        ListView(selectedSkillId: .constant(nil))
            .environmentObject(DataManager())
            .environmentObject(ContentViewModel())
    }
}
