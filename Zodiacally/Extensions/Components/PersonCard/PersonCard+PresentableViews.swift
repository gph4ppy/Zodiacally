//
//  PersonCard+PresentableViews.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 13/07/2021.
//

import SwiftUI

// MARK: - Presentable Views
extension PersonCard {
    // An image, which shows person's photo/app logo.
    @ViewBuilder func customImage(imageSize: CGFloat) -> some View {
        if colorScheme == .dark {
            if containsCustomImage {
                ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                    .personImage(imageSize: imageSize, isStrokeNeeded: true)
            } else {
                ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                    .colorInvert()
                    .personImage(imageSize: imageSize, isStrokeNeeded: true)
            }
        } else {
            ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                .colorInvert()
                .personImage(imageSize: imageSize, isStrokeNeeded: true)
        }
    }
    
    // The card which is visible when the edit mode is turned off.
    @ViewBuilder var defaultCard: some View {
        HStack(spacing: 20) {
            // Image
            customImage(imageSize: imageSize)
                .accessibility(label: Text("\(LocalizedStrings.detailImage) \(person.name)"))
            
            // Data
            VStack(alignment: .leading, spacing: 6) {
                Text(person.name)
                    .font(.title3)
                    .fontWeight(.medium)
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedStrings.zodiac)
                            .labelStyle()
                        Text(LocalizedStrings.birthday)
                            .labelStyle()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(person.zodiacSign)
                            .offset(x: -2)
                        Text(UserDataManager.shared.dateFormatter.string(from: person.birthDate))
                    }
                    .font(.footnote)
                }
            }
            .foregroundColor(Color(.systemBackground))
            
            Spacer()
        }
        .cardModifier(cornerRadius: 15)
        .contextMenu { makeContextMenu() }
        .onAppear(perform: assignImage)
    }
    
    // The card which is visible when the edit mode is turned on.
    @ViewBuilder var editableCard: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center, spacing: 18) {
                // Image
                customImage(imageSize: imageSize - 20)
                    .accessibility(label: Text("\(LocalizedStrings.detailImage) \(person.name)"))
                
                Text(person.name)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            // Data
            HStack(spacing: 18) {
                VStack(alignment: .center, spacing: 4) {
                    Text(LocalizedStrings.zodiac)
                        .labelStyle()
                    Text(person.zodiacSign)
                }
                
                VStack(alignment: .center, spacing: 4) {
                    Text(LocalizedStrings.birthday)
                        .labelStyle()
                    Text(person.birthday)
                }
                .font(.footnote)
            }
        }
        .cardModifier(cornerRadius: 15)
        .contextMenu { makeContextMenu() }
        .onAppear(perform: assignImage)
        .foregroundColor(Color(.systemBackground))
    }
    
    // Context menu, which allows user to copy informations about selected person.
    @ViewBuilder func makeContextMenu() -> some View {
        // Copy Name
        Button(action: {
            UIPasteboard.general.string = person.name
        }) {
            HStack {
                Image(systemName: "person.fill")
                Text(LocalizedStrings.copyName)
            }
        }
        
        // Copy Birthday
        Button(action: {
            UIPasteboard.general.string = person.birthday
        }) {
            HStack {
                Image(systemName: "calendar")
                Text(LocalizedStrings.copyBirthday)
            }
        }
        
        // Copy Zodiac Sign
        Button(action: {
            UIPasteboard.general.string = person.zodiacSign
        }) {
            HStack {
                Image(systemName: "person.2.square.stack.fill")
                Text(LocalizedStrings.copyZodiacSign)
            }
        }
        
        // Copy informations about this person
        Button(action: {
            UIPasteboard.general.string = person.about
        }) {
            Image(systemName: "person.crop.square.fill.and.at.rectangle")
            Text(LocalizedStrings.copyAboutInfo)
        }
    }
}
