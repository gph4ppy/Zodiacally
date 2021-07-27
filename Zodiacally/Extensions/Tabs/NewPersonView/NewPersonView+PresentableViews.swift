//
//  NewPersonView+PresentableViews.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 11/07/2021.
//

import SwiftUI

// MARK: - Presentable Views
extension NewPersonView {
    /// This method creates the toolbar.
    /// - Returns: Toolbar Buttons
    @ToolbarContentBuilder func makeToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                // Favourite Button
                Button(action: { self.isFavourite.toggle() }) {
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .offset(y: 2)
                }
                .accessibility(label: Text(isFavourite ? LocalizedStrings.removePersonFromFavs : LocalizedStrings.addPersonToFavs))
                
                // Save Button
                Button(action: savePerson) {
                    Image(systemName: "square.and.arrow.down")
                }
                .accessibility(label: Text(LocalizedStrings.save))
            }
        }
    }
    
    // A form where data about the close person is typed.
    @ViewBuilder var personForm: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Name TextField
            TextField(LocalizedStrings.name, text: $name)
                .font(.title3)
                .disableAutocorrection(true)
            
            Divider()
            
            HStack {
                Text(LocalizedStrings.birthday)
                Spacer()
                Button(action: { withAnimation { self.showingBirthdayPicker.toggle() } }) {
                    Text(UserDataManager.shared.dateFormatter.string(from: birthday))
                }
            }
            
            Divider()
            
            // Zodiac Sign
            HStack {
                Text(LocalizedStrings.zodiacSign)
                Spacer()
                Text(UserDataManager.shared.setZodiac(from: birthday).symbol)
            }
            
            Divider()
            
            // Group
            HStack {
                Text(LocalizedStrings.group)
                Spacer()
                Picker(selectedGroup, selection: $selectedGroup) {
                    ForEach(groups, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Divider()
            
            // About
            Text(LocalizedStrings.about)
                .font(.title2)
            TextEditor(text: $about)
                .foregroundColor(.gray)
                .offset(x: -4, y: -10)
        }
    }
    
    /// This method shows the alert when the user tries to save a person with an empty name
    func showAlert() {
        DispatchQueue.main.async {
            alertTitle = LocalizedStrings.emptyNameTitle
            alertMessage = LocalizedStrings.emptyNameBody
            showingAlert = true
        }
    }
}
