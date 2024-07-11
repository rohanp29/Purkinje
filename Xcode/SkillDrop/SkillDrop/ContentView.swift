//
//  ContentView.swift
//  SkillDrop
//
//  Created by Devin Weikert on 7/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            ZStack {
                Color.blue
                RoundedRectangle(cornerRadius: 30.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.linearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width:1000, height: 400)
                    .rotationEffect(.degrees(135))
                    .offset(y:-350)
                
                VStack(spacing:20){
                    Text("Skill Drop")
                        .foregroundColor(.white)
                        .font(.system(size:40,weight:.bold, design: .rounded))
                        .offset(x:-100, y:-100)
                    
                    TextField("Email", text:$email)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
                }
                .frame(width:350)
            }
            .ignoresSafeArea()
        }
        //.padding()
    }
}

#Preview {
    ContentView()
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder:() -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
            }
        }
    
}
