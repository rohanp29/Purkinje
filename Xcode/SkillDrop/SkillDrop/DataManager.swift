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
            guard error == nil else{
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
    
    func incrementSkillCount(skillId: String) {
            let db = Firestore.firestore()
            let ref = db.collection("Skills").document(skillId)
            ref.updateData([
                "count": FieldValue.increment(Int64(1))
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                    // Optionally update the local skill count as well
                    if let index = self.skills.firstIndex(where: { $0.id == skillId }) {
                        self.skills[index].count += 1
                    }
                }
            }
        }
}

