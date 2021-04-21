//
//  People+CoreDataProperties.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/04/2021.
//
//

import Foundation
import CoreData

extension People {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var birthday: String
    @NSManaged public var zodiacSign: String
    @NSManaged public var group: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var about: String
    @NSManaged public var displayOrder: Int16
    @NSManaged public var image: Data
    @NSManaged public var birthDate: Date
    @NSManaged public var didSetNotification: Bool
}

extension People : Identifiable {
}
