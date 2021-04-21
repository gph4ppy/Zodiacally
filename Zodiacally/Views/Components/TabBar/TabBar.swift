//
//  TabBar.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/04/2021.
//

import SwiftUI

struct TabBar: View {
    // Properties
    @Binding var selectedTab: String
    let tabs = ["person.circle", "heart.text.square", "gear"]
    
    /* ---------- Body ---------- */
    var body: some View {
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { imageName in
                TabButton(selectedTab: $selectedTab, imageName: imageName)
                
                if imageName != tabs.last {
                    Divider()
                }
            }
        }
        .font(.system(size: 25))
        .padding()
        .frame(height: 65)
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.4), radius: 15)
    }
}
