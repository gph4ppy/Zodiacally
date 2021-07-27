//
//  Date+GetDateComponents.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 05/04/2021.
//

import Foundation

// Get components from the date - year, day, month, etc.
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
