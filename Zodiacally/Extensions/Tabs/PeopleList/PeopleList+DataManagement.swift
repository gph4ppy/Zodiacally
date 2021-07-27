//
//  PeopleList+DataManagement.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/07/2021.
//

import SwiftUI

// MARK: - Data Management
extension PeopleList {
    /// This method moves object at another index
    /// - Parameters:
    ///   - source: where is that object now
    ///   - destination: where it will be placed (on which index)
    func move(from source: IndexSet, to destination: Int) {
        DispatchQueue.main.async {
            var revisedItems: [People] = people.map{ $0 }
            revisedItems.move(fromOffsets: source, toOffset: destination)
            
            for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
                revisedItems[reverseIndex].displayOrder = Int16(reverseIndex)
            }
            
            PersistenceController.shared.saveContext()
        }
    }
    
    /// This method removes person from the context
    /// - Parameter offsets: on which index is the person that will be removed
    func delete(at offsets: IndexSet) {
        DispatchQueue.main.async {
            withAnimation {
                offsets.map { people[$0] }.forEach(viewContext.delete)
            }
            
            PersistenceController.shared.saveContext()
        }
    }
}
