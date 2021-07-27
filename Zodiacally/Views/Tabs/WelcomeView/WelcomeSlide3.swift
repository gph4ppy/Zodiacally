//
//  WelcomeSlide3.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/07/2021.
//

import SwiftUI

struct WelcomeSlide3: View {
    // Properties
    @State private var showingHomeScreen = false
    
    var body: some View {
        ZStack {
            Background()
            
            // Accessibility Scroll View
            GeometryReader { geom in
                ScrollView(.vertical) {
                    VStack {
                        // Title and Subtitle
                        Text(LocalizedStrings.welcomeTitle3)
                            .font(.largeTitle)
                        
                        Text(LocalizedStrings.welcomeBody3)
                            .font(.headline)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        // Show Home Screen
                        Button(action: showHomeScreen) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 44))
                                .foregroundColor(.green)
                                .shadow(radius: 10)
                        }
                        .padding(2)
                        .accessibility(label: Text(LocalizedStrings.showHomeScreen))
                    }
                    .frame(width: geom.size.width)
                    .frame(minHeight: geom.size.height)
                    .multilineTextAlignment(.center)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingHomeScreen) {
            HomeView()
        }
    }
    
    /// This method saves through UserDefaults information that the user has not logged in for the first time and shows Home Screen.
    func showHomeScreen() {
        self.showingHomeScreen = true
        UserDefaults.standard.set(false, forKey: "firstTime")
    }
}
