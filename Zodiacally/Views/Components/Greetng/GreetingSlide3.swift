//
//  GreetingSlide3.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/04/2021.
//

import SwiftUI

struct GreetingSlide3: View {
    // Properties
    @State private var showingHomeScreen = false
    
    /* ---------- Body ---------- */
    var body: some View {
        VStack {
            VStack {
                // Title and Subtitle
                Text("Everything is done!")
                    .font(.largeTitle)
                Text("You can switch to the home view by using the button below.")
                    .font(.title3)
            }
            .padding(.bottom)
            
            Spacer()
                .frame(height: 50)
            
            // Description
            VStack {
                Text("""
                    Remember that holding some components allows you to unlock new functions.

                    Hold a person's card on the home screen to copy the necessary information about that person.
                    """)
                    .font(.callout)
                
                Spacer()
                    .frame(height: 50)
                
                // Image
                Image(systemName: "checkmark.seal")
                    .resizable()
                    .frame(width: 225, height: 225)
                    .padding(20)
            }
            
            Spacer()
            
            // Show Home Screen
            HStack {
                Spacer()
                Button(action: {
                    self.showingHomeScreen = true
                    UserDefaults.standard.set(false, forKey: "firstTime")
                }) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 50))
                        .foregroundColor(Color(.label))
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingHomeScreen) {
            HomeView()
        }
    }
}
