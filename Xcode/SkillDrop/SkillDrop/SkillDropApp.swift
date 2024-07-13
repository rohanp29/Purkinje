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
                .onAppear {
                    NotificationCenter.default.addObserver(forName: .showNISettingsAlert, object: nil, queue: .main) { _ in
                        showNISettingsAlert()
                    }
                    NotificationCenter.default.addObserver(forName: .showNIRestartAlert, object: nil, queue: .main) { _ in
                        showNIRestartAlert()
                    }
                }
        }
    }

    func showNISettingsAlert() {
        let alert = UIAlertController(title: "Access Required", message: "NIPeekaboo requires access to Nearby Interactions. You can change access for this app in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func showNIRestartAlert() {
        let alert = UIAlertController(title: "Access Required", message: "NIPeekaboo requires access to Nearby Interactions. Please restart the app to allow access.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let showNISettingsAlert = Notification.Name("showNISettingsAlert")
    static let showNIRestartAlert = Notification.Name("showNIRestartAlert")
}
