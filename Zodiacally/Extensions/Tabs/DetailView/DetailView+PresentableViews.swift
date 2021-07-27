//
//  DetailView+PresentableViews.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 15/07/2021.
//

import SwiftUI

// MARK: - Presentable Views
extension DetailView {
    /// This method creates the toolbar.
    /// - Returns: Toolbar Buttons
    @ToolbarContentBuilder func makeToolbar() -> some ToolbarContent {
        // --- LEADING ---
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                // Back Button
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                }
                .accessibility(label: Text(LocalizedStrings.goBack))
                
                // Edit Mode Button
                Button(action: { self.showingSheet = true }) {
                    Image(systemName: "slider.horizontal.3")
                }
                .accessibility(label: Text(LocalizedStrings.showEditActions))
            }
        }
        
        // --- TRAILING ---
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                // Love Button
                Button(action: manageFavouriteState) {
                    Image(systemName: person.isFavourite ? "heart.fill" : "heart")
                }
                .accessibility(label: Text(person.isFavourite ? LocalizedStrings.removePersonFromFavs : LocalizedStrings.addPersonToFavs))
                
                // Notification Button
                notificationButton
                    .accessibility(label: Text(person.didSetNotification ? LocalizedStrings.removeNotification : LocalizedStrings.addNotification))
            }
        }
    }
    
    /// This method creates an ActionSheet, which shows the options for editing a person's profile.
    /// - Returns: Action Sheet with edit actions
    func makeActionSheet() -> ActionSheet {
        // Buttons
        let buttons: [ActionSheet.Button] = [
            // Change Image
            .default(Text(LocalizedStrings.image)) { self.showingImagePicker = true },
            
            // Change Name
            .default(Text(LocalizedStrings.name)) {
                setupAlert(title: LocalizedStrings.changeNameTitle,
                           message: LocalizedStrings.changeNameBody,
                           placeholder: LocalizedStrings.changeNamePlaceholder,
                           selectedOption: .name)
            },
                
            // Change Group
            .default(Text(LocalizedStrings.group)) {
                setupAlert(title: LocalizedStrings.editGroupTitle,
                           message: LocalizedStrings.editGroupBody,
                           placeholder: LocalizedStrings.editGroupPlaceholder,
                           selectedOption: .group)
                },
            
            // Change About
            .default(Text(LocalizedStrings.about), action: showEditAboutTextView),
            
            // Cancel Button
            .destructive(Text(LocalizedStrings.cancel))
        ]
        
        // Setup ActionSheet
        return ActionSheet(title: Text(LocalizedStrings.editMode),
                    message: Text(LocalizedStrings.editSheetBody),
                    buttons: buttons)
    }
    
    // Notification Button
    @ViewBuilder var notificationButton: some View {
        Button(action: {
            if person.didSetNotification {
                // Clear notifications with this id (name)
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [person.name])
                
                // Now this user doesn't have pending notifications
                // Set value to the false, so it will set button label to "Notify"
                // It will unlock the schedule option
                self.person.objectWillChange.send()
                self.person.didSetNotification = false
                
                // Save Context
                PersistenceController.shared.saveContext()
            } else {
                // Show time picker - then schedule notification
                showDatePickerAlert()
            }
        }) {
            Image(systemName: person.didSetNotification ? "calendar.badge.minus" : "calendar.badge.plus")
        }
    }
    
    // User's Image
    @ViewBuilder func customImage(imageSize: CGFloat) -> some View {
        if colorScheme == .dark || !containsCustomImage {
            ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                .colorInvert()
                .personImage(imageSize: imageSize, isStrokeNeeded: true)
                .colorInvert()
        } else {
            ProfileImagePlaceholder(image: $image, inputImage: .constant(nil))
                .personImage(imageSize: imageSize, isStrokeNeeded: true)
                .colorInvert()
        }
    }
    
    // Favorite Button
    @ViewBuilder var favouriteAlert: some View {
        VStack {
            Spacer()
            Text(person.isFavourite ? "\(person.name) \(LocalizedStrings.addedToFavs)" : "\(person.name) \(LocalizedStrings.removedFromFavs)")
                .padding()
                .background(Color(.label).opacity(0.8))
                .foregroundColor(Color(.systemBackground))
                .frame(height: 40)
                .clipShape(Capsule())
                .offset(y: -50)
                .padding(4)
        }
    }
    
    /// This method shows the DatePicker and schedules a notification
    private func showDatePickerAlert() {
        // Setup Alert and Date Picker
        let alertVC = UIAlertController(title: LocalizedStrings.chooseNotificationTime,
                                        message: nil,
                                        preferredStyle: .alert)
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        alertVC.view.addSubview(datePicker)
        
        // Activate Anchors
        NSLayoutConstraint.activate([
            // Vertical Anchors
            datePicker.centerYAnchor.constraint(equalTo: alertVC.view.centerYAnchor),
            
            // Horizontal Anchors
            datePicker.centerXAnchor.constraint(equalTo: alertVC.view.centerXAnchor)
        ])
        
        // Set Sheet Height
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view!,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.1,
                                                            constant: 150)
        alertVC.view.addConstraint(height)
        
        // Save Action
        alertVC.addAction(UIAlertAction(title: LocalizedStrings.save, style: .default) { _ in
            let time = datePicker.date
            let hour = time.get(.hour)
            let minute = time.get(.minute)
            
            UserDataManager.shared.registerNotification(identifier: person.name + UUID().uuidString,
                                                        name: person.name,
                                                        date: person.birthDate,
                                                        hour: hour,
                                                        minute: minute)
            
            self.person.objectWillChange.send()
            self.person.didSetNotification = true
            
            self.didSetNotification = true
            self.notificationTime = "\(hour):\(minute)"
            
            PersistenceController.shared.saveContext()
        })
        
        // Cancel Action
        alertVC.addAction(UIAlertAction(title: LocalizedStrings.cancel, style: .cancel))
        
        // Present Sheet
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
    /// This method shows the TextView alert and saves it's content as a user's about info
    func showEditAboutTextView() {
        let alertVC = UIAlertController(title: LocalizedStrings.editAbout,
                                        message: nil,
                                        preferredStyle: .alert)
        let textView: UITextView = UITextView()
        textView.text = self.aboutText
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
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view!,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.1,
                                                            constant: 200)
        alertVC.view.addConstraint(height)
        
        // Save Action
        alertVC.addAction(UIAlertAction(title: LocalizedStrings.save, style: .default) { _ in
            if let aboutString = textView.text {
                self.aboutText = aboutString
                savePersonAbout()
            }
        })
        
        // Cancel Action
        alertVC.addAction(UIAlertAction(title: LocalizedStrings.cancel, style: .cancel))
        
        // Present Sheet
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
    /// This method setups the alert
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: body of the alert
    ///   - placeholder: placeholder of the alert
    ///   - selectedOption:
    private func setupAlert(title: String, message: String, placeholder: String, selectedOption: EditAlertOptions) {
        self.alertTitle = LocalizedStrings.changeNameTitle
        self.alertMessage = message
        self.alertPlaceholder = placeholder
        self.selectedOption = selectedOption
        self.showingTextFieldAlert = true
    }
}
