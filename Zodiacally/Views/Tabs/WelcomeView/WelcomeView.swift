//
//  WelcomeView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 03/07/2021.
//

import SwiftUI

struct WelcomeView: View {
    // Properties
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                
                VStack {
                    Text(LocalizedStrings.welcomeTitle1)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding([.top, .horizontal])
                    
                    Image(decorative: "Cake")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 75)
                    
                    // Accessibility ScrollView
                    // When the text is too large, this will allow people to scroll down instead of cutting it. 
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(LocalizedStrings.welcomeBody1)
                            .font(.callout)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Next Slide
                    HStack {
                        Spacer()
                        NavigationLink(destination: WelcomeSlide2()) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30))
                                .foregroundColor(Color(.label))
                        }
                    }
                    .padding([.trailing, .bottom])
                    .accessibility(label: Text(LocalizedStrings.nextWelcomeSlide))
                }
                .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
