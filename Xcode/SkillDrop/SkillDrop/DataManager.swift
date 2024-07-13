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
                    
                    let documentID = document.documentID
                    let skilltype = data["skilltype"] as? String ?? ""
                    let count = data["count"] as? Int ?? 0
                    
                    let skill = Skill(documentID: documentID, skilltype: skilltype, count: count)
                    self.skills.append(skill)
                }
            }
        }
    }

    func incrementSkillCount(skill: Skill) {
        let db = Firestore.firestore()
        let ref = db.collection("Skills").document(skill.documentID)
        
        ref.updateData([
            "count": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.fetchSkills()
            }
        }
    }
}
