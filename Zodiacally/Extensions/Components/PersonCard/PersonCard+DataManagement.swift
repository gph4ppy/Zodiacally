//
//  PersonCard+DataManagement.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 13/07/2021.
//

import SwiftUI

// MARK: - Data Management
extension PersonCard {
    /// This method assigns person's image to the image property
    func assignImage() {
        if let data = person.image,
           let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
            self.containsCustomImage = true
        } else {
            self.containsCustomImage = false
        }
    }
}
