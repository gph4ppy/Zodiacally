//
//  DetailView+DataManagement.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 14/07/2021.
//

import SwiftUI

// MARK: - Data Management
extension DetailView {
    /// This method assigns data about the user to properties.
    func assignData() {
        assignImageData()
        assignAboutData()
        assignNameData(name: person.name)
    }
    
    /// This method assigns person's image to the image property
    private func assignImageData() {
        if let data = person.image,
           let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
            self.containsCustomImage = true
        } else {
            self.containsCustomImage = false
        }
    }
    
    /// This method assigns data about the person to the variable.
    private func assignAboutData() {
        aboutText = person.about
    }
    
    /// This method assigns the person's name and last name to the variable.
    func assignNameData(name: String) {
        var nameArray = name.components(separatedBy: .whitespaces)
        self.lastName = nameArray.last ?? ""
        nameArray = nameArray.dropLast()
        
        if nameArray.isEmpty {
            self.name = person.name
            self.lastName = ""
        } else {
            self.name = nameArray.joined(separator: " ")
        }
    }
    
    /// This method adds and removes the person in and from the favourite list.
    func manageFavouriteState() {
        // Show the alert about it
        withAnimation(.easeInOut(duration: 0.5)) {
            makePersonFavourite(isFavourite: !person.isFavourite)
            self.showingFavouriteAlert = true
        }
        
        // Hide the alert about it
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingFavouriteAlert = false
            }
        }
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.image = Image(uiImage: inputImage)
        changePersonImage(image: imageData)
    }
    
    /// This method saves data from TextField and then it cleans its content.
    func saveAndClearTextFieldData(_ : String) -> Void {
        if !newTextData.isEmpty {
            self.selectedOption == .name ? changePersonName(to: newTextData) : changePersonGroup(to: newTextData)
            newTextData = ""
        }
    }
}
