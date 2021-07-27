//
//  PersonImageModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/07/2021.
//

import SwiftUI

struct PersonImageModifier: ViewModifier {
    let imageSize: CGFloat
    let isStrokeNeeded: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(UIColor.systemBackground), lineWidth: isStrokeNeeded ? 3 : 0)
                    .padding(-6)
            )
            .padding(.leading, 8)
    }
}
