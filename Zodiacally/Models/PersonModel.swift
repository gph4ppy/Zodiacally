//
//  PersonModel.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import Foundation

struct Person: Hashable {
    let id: String
    let name: String
    let birthday: String
    let zodiacSign: String
    let group: String
    let isFavourite: Bool
    let about: String
    let image: Data?
    let birthDate: Date
    let didSetNotification: Bool
}
