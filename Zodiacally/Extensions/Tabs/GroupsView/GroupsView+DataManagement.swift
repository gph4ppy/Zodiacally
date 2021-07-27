//
//  GroupsView+DataManagement.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 11/07/2021.
//

import SwiftUI

// MARK: - Data Management
extension GroupsView {
    /// This method appends a new group name to the group array.
    func addNewGroup() {
        withAnimation {
            // Append new group to the array when user taps "Save"
            // Then reset it to the default empty value
            if !newGroup.isEmpty {
                groups.append(newGroup)
                newGroup = ""
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
