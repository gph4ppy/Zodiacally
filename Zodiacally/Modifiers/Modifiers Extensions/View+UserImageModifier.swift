//
//  View+UserImageModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/07/2021.
//

import SwiftUI

extension View {
    func userImage() -> some View {
        self.modifier(UserImageModifier())
    }
}
