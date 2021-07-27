//
//  SettingsView+PresentableViews.swift
//  SettingsView+PresentableViews
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 19/07/2021.
//

import SwiftUI

// MARK: - Presentable Views
extension SettingsView {
    // Rectangle with user's profile image button
    @ViewBuilder var profileImage: some View {
        Rectangle()
            .fill(Color(.label).opacity(0.1))
            .blur(radius: 20)
            .shadow(radius: 10)
            .overlay(
                // Image Button
                Button(action: { self.showingImagePicker = true }) {
                    userImage
                        .aspectRatio(contentMode: .fit)
                        .userImage()
                }
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
                    .shadow(color: .primary, radius: 1)
                    .padding(.vertical, 36)
                    .padding(.top)
            )
            .frame(maxHeight: 200)
    }
    
    // User's profile Image
    @ViewBuilder var userImage: some View {
        if let imageData = imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            ProfileImagePlaceholder(image: $image, inputImage: $inputImage)
        }
    }
    
    @ViewBuilder var userDataSection: some View {
        Section(header: Text(LocalizedStrings.informations).foregroundColor(.gray)) {
            // Name
            HStack {
                Text(LocalizedStrings.name)
                Spacer(minLength: 50)
                Text(name)
                    .foregroundColor(.gray)
            }
            
            // Birthday
            HStack {
                Text(LocalizedStrings.birthday)
                Spacer()
                Text(birthday)
                    .foregroundColor(.gray)
            }
            
            // Zodiac Sign
            HStack {
                Text(LocalizedStrings.zodiacSign)
                Spacer()
                Text(zodiacSign)
                    .foregroundColor(.gray)
            }
            
            // About
            if !about.isEmpty {
                VStack(alignment: .leading) {
                    Text(LocalizedStrings.aboutMe)
                        .padding(.bottom, 1)
                    Text(about)
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .listRowBackground(Color.clear)
    }
    
    // App Settings Section
    @ViewBuilder var settingsSection: some View {
        Section(header: Text(LocalizedStrings.settings).foregroundColor(.gray)) {
            // Change Name
            Button(LocalizedStrings.changeNameTitle) {
                self.showingNameAlert = true
            }
            
            // Change birthday
            Button(LocalizedStrings.changeBirthday) {
                withAnimation { self.showingBirthdayPicker = true }
            }
            
            // Edit about
            Button(LocalizedStrings.editAboutMe) {
                showTextViewAlert()
            }
            
            // Accent Color Picker
            ZStack(alignment: .leading) {
                NavigationLink(destination: ColorsView(selectedColor: $accentColor), isActive: $showingColors) {
                    EmptyView()
                }
                .hidden()
                .frame(height: 0)
                
                Button(action: { self.showingColors = true }) {
                    HStack(spacing: 5) {
                        Text(LocalizedStrings.accentColor)
                        
                        Spacer()
                        
                        Color(accentColor)
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                            .padding(.trailing, 5)
                        Text(UserDataManager.shared.translateAccentColor(selected: accentColor))
                    }
                }
            }
            
            // Group Manager
            ZStack(alignment: .leading) {
                NavigationLink(destination: GroupsView(), isActive: $showingGroups) {
                    EmptyView()
                }
                .hidden()
                .frame(height: 0)
                
                Button(LocalizedStrings.editGroups) {
                    self.showingGroups = true
                }
            }
            
            // Clear Notifications Button
            Button(LocalizedStrings.clearNotifications) {
                self.alert = Alert(title: Text(LocalizedStrings.clearNotifications),
                                   message: Text(LocalizedStrings.clearNotificationsBody),
                                   primaryButton:
                                        .default(Text(LocalizedStrings.clear), action: {
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                }),
                                   secondaryButton:
                                        .destructive(Text(LocalizedStrings.cancel)))
                self.showingAlert = true
            }
            
            // Credits and licenses
            Button(LocalizedStrings.creditsTitle) {
                self.alert = Alert(title: Text(LocalizedStrings.creditsTitle),
                                   message: Text(LocalizedStrings.creditsBody),
                                   dismissButton: .default(Text("OK")))
                self.showingAlert = true
            }
            
            // App Version
            HStack {
                Text(LocalizedStrings.version)
                Spacer()
                Text(appVersion ?? "⚠️")
                    .foregroundColor(.gray)
            }
        }
        .foregroundColor(.primary)
        .listRowBackground(Color.clear)
    }
    
    /// This method shows the TextView alert and saves it's content as a user's about info
    func showTextViewAlert() {
        let alertVC = UIAlertController(title: LocalizedStrings.editAbout,
                                        message: nil,
                                        preferredStyle: .alert)
        let textView: UITextView = UITextView()
        textView.text = about
        textView.layer.cornerRadius = 15
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.systemBackground
        
        alertVC.view.addSubview(textView)
        
        // Activate Anchors
        NSLayoutConstraint.activate([
            // Vertical Anchors
            textView.topAnchor.constraint(equalTo: alertVC.view.topAnchor, constant: 50),
            textView.bottomAnchor.constraint(equalTo: alertVC.view.bottomAnchor, constant: -50),
            
            // Horizontal Anchors
            textView.leadingAnchor.constraint(equalTo: alertVC.view.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: alertVC.view.trailingAnchor, constant: -15)
        ])
        
        // Set Sheet Height
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 200)
        alertVC.view.addConstraint(height)
        
        // Save Action
        alertVC.addAction(UIAlertAction(title: LocalizedStrings.save, style: .default) { _ in
            if let aboutString = textView.text {
                self.about = aboutString
            }
        })
        
        // Cancel Action
        alertVC.addAction(UIAlertAction(title: LocalizedStrings.cancel, style: .cancel))
        
        // Present Sheet
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
}
