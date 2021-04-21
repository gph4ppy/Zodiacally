//
//  GreetingView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/04/2021.
//

import SwiftUI

struct GreetingView: View {
    // Properties
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    /* ---------- Body ---------- */
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // Title and Subtitle
                    Text("Zodiacally")
                        .font(.largeTitle)
                    Text("Remember the birthday of loved ones")
                        .font(.title3)
                }
                .padding(.bottom)
                
                Spacer()
                    .frame(height: 50)
                
                VStack {
                    // Description
                    Text("""
                        Birthday is the most important day of the year when people celebrate the year of their lives. It is important to remember this day - after all, these are people who are close to us! We want to be with them in their most important moments, but not everything can be remembered.

                        Zodiacally will help you remember the birthdays of people you know.
                        """)
                        .font(.callout)
                    
                    // Logo
                    if colorScheme == .dark {
                        Image("Logo")
                    } else {
                        Image("Logo")
                            .colorInvert()
                    }
                }
                
                Spacer()
                
                // Next Slide
                HStack {
                    Spacer()
                    NavigationLink(destination: GreetingSlide2()) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 50))
                            .foregroundColor(Color(.label))
                    }
                }
            }
            .multilineTextAlignment(.center)
            .padding()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
