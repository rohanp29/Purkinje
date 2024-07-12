//
//  ContentViewModel.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/12/24.
//

import SwiftUI
import Firebase

class ContentViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var userIsLoggedIn = false
    
    init() {
        if Auth.auth().currentUser != nil {
            userIsLoggedIn = true
        }
    }
    
}
