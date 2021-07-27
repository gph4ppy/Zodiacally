//
//  View+CardModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/07/2021.
//

import SwiftUI

extension View {
    func cardModifier(cornerRadius: CGFloat) -> some View {
        self.modifier(CardModifier(cornerRadius: cornerRadius))
    }
}
