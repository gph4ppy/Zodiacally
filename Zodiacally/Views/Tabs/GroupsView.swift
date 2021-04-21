//
//  GroupsView.swift.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 14/04/2021.
//

import SwiftUI

struct GroupsView: View {
    // Properties
    @AppStorage("groups") private var groups: [String]      = ["Family", "Friends", "School", "Work"]
    @State private var newGroup: String                     = ""
    @State private var showingAlert: Bool                   = false
    
    /* ---------- Body ---------- */
    var body: some View {
        ZStack {
            VStack {
                // Groups List
                List {
                    ForEach(groups, id: \.self) {
                        Text($0)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            }
            
            // Alert with TextField - new group name
            if self.showingAlert {
                TextFieldAlert(text: $newGroup, showingAlert: $showingAlert, title: "New Group", message: "Add new group", placeholder: "e.g. Family, Friends, School")
            }
        }
        .navigationBarTitle("Groups")
        .toolbar {
            HStack {
                // Edit Button
                EditButton()
                
                Spacer()
                    .frame(width: 15)
                
                // Show alert with textfield, where user can type the new group name
                Button(action: { self.showingAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onChange(of: newGroup) { _ in
            withAnimation {
                // Append new group to the array when user taps "Save"
                // Then reset it to the default empty value
                if !newGroup.isEmpty {
                    groups.append(newGroup)
                    newGroup = ""
                }
            }
        }
    }
    
    /// This method moves object at another index
    /// - Parameters:
    ///   - source: where is that object now
    ///   - destination: where it will be placed (on which index)
    func move(from source: IndexSet, to destination: Int) {
        groups.move(fromOffsets: source, toOffset: destination)
    }
    
    /// This method removes person from the groups array
    /// - Parameter offsets: on which index is the person that will be removed
    func delete(at offsets: IndexSet) {
        groups.remove(atOffsets: offsets)
    }
}
