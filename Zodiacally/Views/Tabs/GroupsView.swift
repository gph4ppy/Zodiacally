//
//  GroupsView.swift.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 14/04/2021.
//

import SwiftUI

struct GroupsView: View {
    // Properties
    @State var newGroup: String                     = ""
    @State var showingAlert: Bool                   = false
    @AppStorage("groups") var groups: [String]      = [LocalizedStrings.family,
                                                       LocalizedStrings.friends,
                                                       LocalizedStrings.school,
                                                       LocalizedStrings.work]
    
    var body: some View {
        ZStack {
            Background()
            
            // Groups List
            List {
                ForEach(groups, id: \.self) {
                    Text($0)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            
            // Alert with TextField - new group name
            if self.showingAlert {
                TextFieldAlert(text: $newGroup,
                               showingAlert: $showingAlert,
                               title: LocalizedStrings.newGroup,
                               message: LocalizedStrings.addNewGroup,
                               placeholder: "\(LocalizedStrings.family), \(LocalizedStrings.friends), \(LocalizedStrings.school)")
            }
        }
        .navigationBarTitle(LocalizedStrings.groups)
        .toolbar(content: makeToolbar)
        .onChange(of: newGroup) { _ in
            addNewGroup()
        }
    }
}
