//
//  DataManager.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var skills: [Skill] = []
    
    init() {
        fetchSkills()
    }
    
    func fetchSkills() {
        skills.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Skills")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let skilltype = data["skilltype"] as? String ?? ""
                    let count = data["count"] as? Int ?? 0
                    
                    let skill = Skill(id: id, skilltype: skilltype, count: count)
                    self.skills.append(skill)
                }
            }
        }
    }
    
    func updateSkillCount(skill: Skill) {
        let db = Firestore.firestore()
        db.collection("Skills").document(skill.id).updateData([
            "count": skill.count
        ]) { err in
            if let err = err {
                print("Error updating skill count: \(err)")
            } else {
                print("Skill count successfully updated")
            }
        }
    }
}
