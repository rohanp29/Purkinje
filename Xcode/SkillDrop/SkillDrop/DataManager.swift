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
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        fetchSkills()
        startListeningForSkillChanges()
    }
    
    func fetchSkills() {
        let ref = db.collection("Skills")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                self.skills = snapshot.documents.map { document in
                    let data = document.data()
                    
                    let documentID = document.documentID
                    let skilltype = data["skilltype"] as? String ?? ""
                    let count = data["count"] as? Int ?? 0
                    
                    return Skill(documentID: documentID, skilltype: skilltype, count: count)
                }
            }
        }
    }

    func startListeningForSkillChanges() {
        listener = db.collection("Skills").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            var updatedSkills: [Skill] = []
            
            for document in snapshot.documents {
                let data = document.data()
                let documentID = document.documentID
                let skilltype = data["skilltype"] as? String ?? ""
                let count = data["count"] as? Int ?? 0
                
                let skill = Skill(documentID: documentID, skilltype: skilltype, count: count)
                updatedSkills.append(skill)
            }
            
            DispatchQueue.main.async {
                self.skills = updatedSkills
            }
        }
    }
    
    func stopListeningForSkillChanges() {
        listener?.remove()
    }

    func incrementSkillCount(skill: Skill) {
        let ref = db.collection("Skills").document(skill.documentID)
        
        ref.updateData([
            "count": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
