//
//  SettingsView+DataManagement.swift
//  SettingsView+DataManagement
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 19/07/2021.
//

import SwiftUI

// MARK: - Data Management
extension SettingsView {
    /// This method loads the image into placeholder
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.imageData = imageData
        self.image = Image(uiImage: inputImage)
        self.containsCustomImage = true
    }
}
