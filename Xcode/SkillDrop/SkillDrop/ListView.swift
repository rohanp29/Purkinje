//
//  ListView.swift
//  SkillDrop
//
//  Created by Rohan and Rebecca on 7/11/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    
    
    var body: some View {
        NavigationView {
            List(dataManager.skills, id: \.id) { skill in
                            HStack {
                                Text(skill.skilltype)
                                Spacer()
                                Text("\(skill.count)")
                                    .foregroundColor(.gray)
                            }
                        }
            .navigationTitle("Skills")
            .navigationBarItems(trailing: Button(action: {
                //add
            }, label: {
                Image(systemName: "plus")
            }))
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(DataManager())
    }
}
