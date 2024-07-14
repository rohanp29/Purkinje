//
//  Skill.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

import SwiftUI

struct Skill: Identifiable, Equatable {
    var id: String { documentID }
    var documentID: String
    var skilltype: String
    var count: Int
    
    static func ==(lhs: Skill, rhs: Skill) -> Bool {
        return lhs.id == rhs.id
    }
}
