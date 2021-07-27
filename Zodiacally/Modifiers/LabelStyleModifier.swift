//
//  LabelStyleModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 5.0)
            .padding(.vertical, 2.0)
            .background(Color(.darkGray))
            .clipShape(Capsule())
    }
}
