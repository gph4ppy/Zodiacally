//
//  UserImageModifier.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/07/2021.
//

import SwiftUI

struct UserImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .foregroundColor(Color(.label))
            .overlay(
                Circle()
                    .strokeBorder(Color(.label), lineWidth: 5)
                    .padding(-10)
            )
    }
}
