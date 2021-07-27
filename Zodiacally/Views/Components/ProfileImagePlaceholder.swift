//
//  ProfileImagePlaceholder.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/07/2021.
//

import SwiftUI

struct ProfileImagePlaceholder: View {
    // Properties
    @Binding var image: Image
    @Binding var inputImage: UIImage?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        if colorScheme == .dark || inputImage != nil {
            image
                .resizable()
                .userImage()
        } else {
            image
                .resizable()
                .colorInvert()
                .userImage()
        }
    }
}
