//
//  PeopleList+PresentableViews.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/07/2021.
//

import SwiftUI

// MARK: - Presentable Views
extension PeopleList {
    /// This method creates the toolbar.
    /// - Returns: HStack containing buttons and user data.
    @ToolbarContentBuilder func makeToolbar() -> some ToolbarContent {
        // --- LEADING ---
        ToolbarItem(placement: .navigationBarLeading) {
            // Edit Button
            EditButton()
        }
        
        // --- CENTER ---
        ToolbarItem(placement: .principal) {
            // Image and name
            HStack {
                customImage(imageSize: 30)
                    .accessibility(label: Text(LocalizedStrings.yourProfileImage))
                
                Text(name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        
        // --- TRAILING ---
        ToolbarItem(placement: .navigationBarTrailing) {
            // New person button
            NavigationLink(destination: NewPersonView(isVisible: $showingNewPersonForm), isActive: $showingNewPersonForm) {
                Image(systemName: "plus")
            }
            .accessibility(label: Text(LocalizedStrings.addPerson))
        }
    }
    
    // User's Image
    @ViewBuilder func customImage(imageSize: CGFloat) -> some View {
        if colorScheme == .dark || !containsCustomImage {
            ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                .colorInvert()
                .personImage(imageSize: imageSize, isStrokeNeeded: false)
                .colorInvert()
        } else {
            ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                .personImage(imageSize: imageSize, isStrokeNeeded: false)
                .colorInvert()
        }
    }
}
