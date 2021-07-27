//
//  TabButton.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/04/2021.
//

import SwiftUI

struct TabButton: View {
    // Properties
    @Binding var selectedTab: String
    @AppStorage("accentColor") private var accentColor: String = "Purple"
    let imageName: String
    
    var body: some View {
        Button(action: { withAnimation { selectedTab = imageName } }) {
            Image(systemName: imageName)
                .renderingMode(.template)
                .foregroundColor(selectedTab == imageName ? UserDataManager.shared.setAccentColor(from: accentColor) : .gray)
                .padding()
                .accessibility(label: assignAccessibilityLabel(imageName: imageName))
        }
    }
    
    private func assignAccessibilityLabel(imageName: String) -> Text {
        switch imageName {
            case "person.circle": return Text(LocalizedStrings.people)
            case "heart.text.square": return Text(LocalizedStrings.favoritePeople)
            case "gear": return Text(LocalizedStrings.settings)
            default: return Text("")
        }
    }
}
