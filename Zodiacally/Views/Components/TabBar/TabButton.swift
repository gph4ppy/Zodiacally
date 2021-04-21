//
//  TabButton.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/04/2021.
//

import SwiftUI

struct TabButton: View {
    // Properties
    @AppStorage("accentColor") private var accentColor: String      = "Purple"
    @Binding var selectedTab: String
    var imageName: String
    let userDataManager                                             = UserDataManager()
    
    /* ---------- Body ---------- */
    var body: some View {
        Button(action: { selectedTab = imageName }) {
            Image(systemName: imageName)
                .renderingMode(.template)
                .foregroundColor(selectedTab == imageName ? userDataManager.setAccentColor(from: accentColor) : .gray)
                .padding()
        }
    }
}
