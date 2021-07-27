//
//  NewPersonView+DataManagement.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 11/07/2021.
//

import SwiftUI

// MARK: - Data Management
extension NewPersonView {
    /// This method saves the person into the context
    /// - Parameter person: person model, which contains the data to save
    func savePerson() {
        // Check if name is empty
        if name.isEmpty {
            // Name is empty, show warning alert
            showAlert()
        } else {
            DispatchQueue.main.async {
                // Save person to context
                let newPerson = People(context: viewContext)
                
                newPerson.id                    = UUID().uuidString
                newPerson.name                  = self.name
                newPerson.birthday              = UserDataManager.shared.dateFormatter.string(from: birthday)
                newPerson.zodiacSign            = UserDataManager.shared.setZodiac(from: birthday).symbol
                newPerson.isFavourite           = self.isFavourite
                newPerson.group                 = self.selectedGroup
                newPerson.about                 = self.about
                newPerson.image                 = self.imageData
                newPerson.birthDate             = self.birthday
                newPerson.didSetNotification    = false
                
                PersistenceController.shared.saveContext()
                
                // Dismiss View
                // MARK: BUG - The presentationMode itself doesn't work, pops back to this view)
                self.isVisible = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.imageData = imageData
        self.image = Image(uiImage: inputImage)
    }
}
