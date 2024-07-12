//
//  SkillDropApp.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

import SwiftUI
import Firebase

@main
struct SkillDropApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            ListView()
                .environmentObject(dataManager)
        }
    }
}
