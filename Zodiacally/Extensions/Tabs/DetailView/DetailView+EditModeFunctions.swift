//
//  DetailView+EditModeFunctions.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 14/07/2021.
//

import Foundation

// MARK: - Edit Mode Functions
extension DetailView {
    /// This method saves the new image binary data to the context
    /// - Parameter data: new image binary data
    func changePersonImage(image data: Data) {
        self.person.objectWillChange.send()
        self.person.image = data
        
        PersistenceController.shared.saveContext()
    }
    
    /// This method saves the status of whether the person is a favorite in the context
    /// - Parameter isFavourite: the status of whether a person is liked
    func makePersonFavourite(isFavourite: Bool) {
        self.person.objectWillChange.send()
        self.person.isFavourite = isFavourite
        
        PersistenceController.shared.saveContext()
    }
    
    /// This method saves the new name to the context
    /// - Parameter name: new name string
    func changePersonName(to name: String) {
        self.person.objectWillChange.send()
        self.person.name = name
        
        assignNameData(name: name)
        
        PersistenceController.shared.saveContext()
    }
    
    /// This method saves the new group name to the context
    /// - Parameter group: new group name string
    func changePersonGroup(to group: String) {
        self.person.objectWillChange.send()
        self.person.group = group
        
        PersistenceController.shared.saveContext()
    }
    
    /// This method saves the about info to the context
    func savePersonAbout() {
        self.person.objectWillChange.send()
        self.person.about = self.aboutText
        
        PersistenceController.shared.saveContext()
        self.editingAboutField = false
    }
}
