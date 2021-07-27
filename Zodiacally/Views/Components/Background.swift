//
//  Background.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 03/07/2021.
//

import SwiftUI

struct Background: View {
    // Properties
    let size = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            // Background Color
            Color("Background")
                .ignoresSafeArea()
            
            // Blurred Circles
            VStack {
                Circle()
                    .fill(Color.blue)
                    .position(x: 0, y: 0)
                
                Circle()
                    .fill(Color.red)
                    .position(x: size.width,
                              y: size.height / 2)
                
                Circle()
                    .fill(Color.purple)
                    .position(x: 0,
                              y: 0)
            }
            .blur(radius: 125)
        }
    }
}
