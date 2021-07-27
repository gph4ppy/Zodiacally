//
//  ColorsView.swift
//  ColorsView
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 25/07/2021.
//

import SwiftUI

struct ColorsView: View {
    // Properties
    @Binding var selectedColor: String
    let colors                              = ["Red",
                                               "Green",
                                               "Blue",
                                               "Pink",
                                               "Purple",
                                               "Yellow",
                                               "Cyan",
                                               "Mint",
                                               "Gray",
                                               "Orange"]
    
    var body: some View {
        ZStack {
            Background()
            
            // Groups List
            List {
                ForEach(colors, id: \.self) { color in
                    Button(action: { self.selectedColor = color }) {
                        HStack(spacing: 5) {
                            Color(color)
                                .frame(width: 25, height: 25)
                                .clipShape(Circle())
                                .padding(.trailing, 5)
                            Text(UserDataManager.shared.translateAccentColor(selected: color))
                        }
                    }
                }
            }
        }
        .navigationBarTitle(LocalizedStrings.accentColor)
    }
}
