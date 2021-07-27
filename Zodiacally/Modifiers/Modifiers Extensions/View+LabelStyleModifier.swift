//
//  View+LabelStyleModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/07/2021.
//

import SwiftUI

extension View {
    func labelStyle() -> some View {
        self.modifier(LabelStyle())
    }
}
