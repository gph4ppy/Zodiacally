//
//  GroupsView+PresentableViews.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 11/07/2021.
//

import SwiftUI

// MARK: - Presentable Views
extension GroupsView {
    /// This method creates the toolbar.
    /// - Returns: Toolbar Buttons
    @ToolbarContentBuilder func makeToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                // Edit Button
                EditButton()
                
                // Show alert with textfield, where user can type the new group name
                Button(action: { self.showingAlert = true }) {
                    Image(systemName: "plus")
                }
                .accessibility(label: Text(LocalizedStrings.addNewGroup))
            }
        }
    }
}
