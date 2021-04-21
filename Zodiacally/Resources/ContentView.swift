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
    let userDataManager                                             = UserDataManager()
    @Environment(\.managedObjectContext) private var viewContext
    
    /* ---------- Body ---------- */
    var body: some View {
        if isFirstTime {
            GreetingView()
        } else {
            HomeView()
                .accentColor(userDataManager.setAccentColor(from: accentColor))
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}
