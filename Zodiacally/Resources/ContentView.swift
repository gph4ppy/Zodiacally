//
//  ContentView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // Properties
    @AppStorage("firstTime") private var isFirstTime: Bool          = true
    @AppStorage("accentColor") private var accentColor: String      = "Purple"
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        if isFirstTime {
            WelcomeView()
        } else {
            HomeView()
                .accentColor(UserDataManager.shared.setAccentColor(from: accentColor))
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}
