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
    private var listener: ListenerRegistration?

    init() {
        addSkillsListener()
    }

    deinit {
        listener?.remove()
    }

    func addSkillsListener() {
        let db = Firestore.firestore()
        let ref = db.collection("Skills")

        listener = ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Error fetching snapshot: \(error!)")
                return
            }

            guard let snapshot = snapshot else { return }
            
            var newSkills: [Skill] = []
            
            for document in snapshot.documents {
                let data = document.data()
                let id = document.documentID
                let skilltype = data["skilltype"] as? String ?? ""
                let count = data["count"] as? Int ?? 0

                let skill = Skill(id: id, skilltype: skilltype, count: count)
                newSkills.append(skill)
            }
            
            DispatchQueue.main.async {
                self.skills = newSkills
            }
        }
    }

    func incrementSkillCount(skillID: String) {
        let db = Firestore.firestore()
        db.collection("Skills").document(skillID).updateData([
            "count": FieldValue.increment(Int64(1))
        ]) { err in
            if let err = err {
                print("Error updating skill count: \(err)")
            } else {
                print("Skill count successfully updated")
            }
        }
    }
}
