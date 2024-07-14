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
    @StateObject var contentViewModel = ContentViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environmentObject(contentViewModel)
        }
    }
}
