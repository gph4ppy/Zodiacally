//
//  CardModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/07/2021.
//

import SwiftUI

struct CardModifier: ViewModifier {
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .background(
                Color(UIColor.label).opacity(0.8)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(UIColor.tertiarySystemBackground), lineWidth: 5)
            )
    }
}
