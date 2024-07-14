//
//  ContentView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        Group {
            if contentViewModel.userIsLoggedIn {
                if contentViewModel.userRole == "physician" {
                    PhysicianListView()
                        .environmentObject(contentViewModel)
                        .environmentObject(dataManager)
                } else {
                    TraineeListView()
                        .environmentObject(contentViewModel)
                        .environmentObject(dataManager)
                }
            } else {
                loginView
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                contentViewModel.userIsLoggedIn = true
                // Fetch user role if needed
            } else {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        contentViewModel.userIsLoggedIn = true
                        // Fetch user role if needed
                    }
                }
            }
        }
    }
    
    var loginView: some View {
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.blue, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            VStack(spacing: 20) {
                Text("Skill Drop")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                
                TextField("Email", text: $contentViewModel.email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: contentViewModel.email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $contentViewModel.password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: contentViewModel.password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Picker("Role", selection: $contentViewModel.userRole) {
                    Text("Attending Physician").tag("physician")
                    Text("Medical Trainee").tag("trainee")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button {
                    register()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 50)
                
                Button {
                    login()
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 60)
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        contentViewModel.userIsLoggedIn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: contentViewModel.email, password: contentViewModel.password) { result, error in
            if error == nil {
                contentViewModel.userIsLoggedIn = true
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: contentViewModel.email, password: contentViewModel.password) { result, error in
            if error == nil {
                contentViewModel.userIsLoggedIn = true
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

