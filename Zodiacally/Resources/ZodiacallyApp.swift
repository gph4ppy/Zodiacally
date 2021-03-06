//
//  ZodiacallyApp.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct ZodiacallyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    IQKeyboardManager.shared.enable = true
                }
        }
    }
}
