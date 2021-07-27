//
//  WelcomeSlide2+UserDataManagement.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/07/2021.
//

import SwiftUI

// MARK: - User Data Management
extension WelcomeSlide2 {
    /// This method saves the data from the birthday through UserDefaults.
    /// - Parameter birthday: date of birth
    func saveBirthdayData(from birthday: Date) {
        // Prepare data to save
        let date = UserDataManager.shared.dateFormatter.string(from: birthday)
        let zodiac = UserDataManager.shared.setZodiac(from: birthday)
        
        // Save Data with UserDefaults
        self.birthdayString = date
        self.zodiacSign = zodiac.symbol
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.imageData = imageData
        self.image = Image(uiImage: inputImage)
        
        UserDefaults.standard.set(self.imageData, forKey: "userImage")
    }
}
