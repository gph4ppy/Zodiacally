//
//  View+PersonImageModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/07/2021.
//

import SwiftUI

extension View {
    func personImage(imageSize: CGFloat, isStrokeNeeded: Bool) -> some View {
        self.modifier(PersonImageModifier(imageSize: imageSize, isStrokeNeeded: isStrokeNeeded))
    }
}
