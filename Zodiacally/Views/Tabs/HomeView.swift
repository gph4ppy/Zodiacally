//
//  HomeView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI

struct HomeView: View {
    // Properties
    @ObservedObject private var keyboard        = KeyboardResponder()
    @State var selectedTab: String              = "person.circle"
    
    /* ---------- Body ---------- */
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            // Tab View - navigates through tabs
            TabView(selection: $selectedTab) {
                PeopleView(showingFavourites: false)
                    .tag("person.circle")
                
                PeopleView(showingFavourites: true)
                    .tag("heart.text.square")
                
                SettingsView()
                    .tag("gear")
            }
            
            // Custom Tab Bar View
            if keyboard.currentHeight == 0 {
                TabBar(selectedTab: $selectedTab)
                    .offset(y: -15)
            }
        }
    }
}
