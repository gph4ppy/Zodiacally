//
//  DetailView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI

enum EditAlertOptions {
    case name
    case group
}

struct DetailView: View {
    // Properties
    @ObservedObject private var keyboard                        = KeyboardResponder()
    @ObservedObject var person: People
    @State private var newTextData: String                      = ""
    @State private var aboutText                                = ""
    @State private var showingAlert: Bool                       = false
    @State private var showingSheet: Bool                       = false
    @State private var showingTextFieldAlert: Bool              = false
    @State private var editingAboutField: Bool                  = false
    
    // Alert
    @State private var alertTitle: String                       = ""
    @State private var alertMessage: String                     = ""
    @State private var alertPlaceholder: String                 = ""
    @State private var selectedOption: EditAlertOptions         = .name
    
    // Image Picker
    @State private var inputImage: UIImage?
    @State private var showingImagePicker: Bool                 = false
    @State private var image: Image                             = Image(systemName: "person.circle")
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    /* ---------- Body ---------- */
    var body: some View {
        var isFavourite = person.isFavourite
        
        ZStack {
            VStack {
                Divider()
                HStack(spacing: 20) {
                    // Person's image
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color(.label))
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .padding(8)
                        .overlay(
                            Circle()
                                .strokeBorder(Color(.label), lineWidth: 5)
                        )
                        .shadow(color: Color(.label).opacity(0.5), radius: 1)
                    
                    Spacer()
                        .frame(width: 8)
                    
                    // Person's data
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🎂 \(person.birthday)")
                        Text("🪧 \(person.zodiacSign)")
                        Text("👥 \(person.group)")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    
                }
                .padding()
                .blur(radius: keyboard.currentHeight)
                
                Divider()
                
                // About field
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("About")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        // Edit Mode Buttons
                        if editingAboutField {
                            // Dismiss Keyboard
                            if keyboard.currentHeight != 0 {
                                Button("Dismiss") {
                                    UIApplication.shared.endEditing()
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal)
                            }
                            
                            // Save Button
                            Button("Save") {
                                savePersonAbout()
                            }
                        }
                    }
                    
                    // If user is in editor mode
                    if editingAboutField {
                        // Show Text Editor
                        TextEditor(text: $aboutText)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .frame(height: UIScreen.main.bounds.height / 3)
                            .cornerRadius(15)
                    } else {
                        // Otherwise show Text in vertical ScrollView
                        ScrollView(.vertical) {
                            HStack {
                                Text(person.about)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 40)
                    }
                }
                .padding()
                
                Spacer()
            }
            .toolbar {
                HStack {
                    // Schedule Notification Button
                    Button(person.didSetNotification ? "Clear Notification" : "Notify") {
                        // Check if notifications have been set for this person
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
                            saveContext()
                        } else {
                            // Show time picker - then schedule notification
                            showDatePickerAlert()
                        }
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    // Edit Button - shows Action Sheet
                    Button("Edit") {
                        self.showingSheet = true
                    }
                    .actionSheet(isPresented: $showingSheet) {
                        // Setup ActionSheet
                        ActionSheet(title: Text("Edit Mode"),
                                    message: Text("What would you like to change?"),
                                    buttons: [
                                        // Change Image
                                        .default(Text("Image")) {
                                            self.showingImagePicker = true
                                        },
                                        // Change Name
                                        .default(Text("Name")) {
                                            self.alertTitle = "Change Name"
                                            self.alertMessage = "Type the new name below"
                                            self.alertPlaceholder = "New Name"
                                            self.selectedOption = .name
                                            self.showingTextFieldAlert = true
                                        },
                                        // Change Group
                                        .default(Text("Group")) {
                                            self.alertTitle = "Edit Group"
                                            self.alertMessage = "Type name of the new group below"
                                            self.alertPlaceholder = "e. g. Family, School, Friends"
                                            self.selectedOption = .group
                                            self.showingTextFieldAlert = true
                                        },
                                        // Change About
                                        .default(Text("About")) {
                                            self.editingAboutField = true
                                        },
                                        // Cancel Button
                                        .destructive(Text("Cancel"))
                                    ])
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    // Favourite Button
                    Button(action: {
                        // Add and Remove the person from favourite list
                        // Then show the alert about it
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isFavourite.toggle()
                            makePersonFavourite(isFavourite: isFavourite)
                            showingAlert = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showingAlert = false
                            }
                        }
                        
                    }) {
                        Image(systemName: person.isFavourite ? "heart.fill" : "heart")
                    }
                }
            }
            .padding(.top)
            .navigationBarTitle(person.name)
            .onAppear {
                if let uiImage = UIImage(data: person.image) {
                    image = Image(uiImage: uiImage)
                }
                
                aboutText = person.about
            }
            .onChange(of: newTextData) { _ in
                if !newTextData.isEmpty {
                    self.selectedOption == .name ? changePersonName(to: newTextData) : changePersonGroup(to: newTextData)
                    newTextData = ""
                }
            }
            
            // Alert informing about the change of the user's state about being on the favorites list
            if showingAlert {
                VStack {
                    Spacer()
                    Text(isFavourite ? "\(person.name) has been added to favorites." : "\(person.name) has been removed from favorites.")
                        .padding()
                        .foregroundColor(.primary)
                        .colorInvert()
                        .background(Color(.label).opacity(0.8))
                        .frame(height: 40)
                        .clipShape(Capsule())
                        .offset(y: -50)
                }
            }
            
            // Alert for groups and name
            if self.showingTextFieldAlert {
                TextFieldAlert(text: $newTextData, showingAlert: $showingTextFieldAlert, title: alertTitle, message: alertMessage, placeholder: alertPlaceholder)
            }
        }
        .offset(y: keyboard.currentHeight != 0 && editingAboutField ? -self.keyboard.currentHeight * 0.25 : 0)
        .sheet(isPresented: self.$showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    private func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.image = Image(uiImage: inputImage)
        changePersonImage(image: imageData)
    }
    
    /// This method shows the datepicker and schedules a notification
    func showDatePickerAlert() {
        // Setup Alert and Date Picker
        let alertVC = UIAlertController(title: "Choose notification time",
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
            datePicker.topAnchor.constraint(equalTo: alertVC.view.topAnchor, constant: 0),
            datePicker.bottomAnchor.constraint(equalTo: alertVC.view.bottomAnchor, constant: -20),
            
            // Horizontal Anchors
            datePicker.centerXAnchor.constraint(equalTo: alertVC.view.centerXAnchor)
        ])
        
        // Set Sheet Height
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 150)
        alertVC.view.addConstraint(height)
        
        // Save Action
        alertVC.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let userDataManager = UserDataManager()
            let time = datePicker.date
            
            let hour = time.get(.hour)
            let minute = time.get(.minute)
            
            userDataManager.registerNotification(identifier: person.name, date: person.birthDate, hour: hour, minute: minute)
            
            self.person.objectWillChange.send()
            self.person.didSetNotification = true
            
            saveContext()
        })
        
        // Cancel Action
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present Sheet
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - EDIT MODE FUNCTIONS
    /// This method saves the new image binary data to the context
    /// - Parameter data: new image binary data
    private func changePersonImage(image data: Data) {
        self.person.objectWillChange.send()
        self.person.image = data
        
        saveContext()
    }
    
    /// This method saves the status of whether the person is a favorite in the context
    /// - Parameter isFavourite: the status of whether a person is liked
    private func makePersonFavourite(isFavourite: Bool) {
        self.person.objectWillChange.send()
        self.person.isFavourite = isFavourite
        
        saveContext()
    }
    
    /// This method saves the new name to the context
    /// - Parameter name: new name string
    private func changePersonName(to name: String) {
        self.person.objectWillChange.send()
        self.person.name = name
        
        saveContext()
    }
    
    /// This method saves the new group name to the context
    /// - Parameter group: new group name string
    private func changePersonGroup(to group: String) {
        self.person.objectWillChange.send()
        self.person.group = group
        
        saveContext()
    }
    
    /// This method saves the about ingo to the context
    private func savePersonAbout() {
        self.person.objectWillChange.send()
        self.person.about = self.aboutText
        
        saveContext()
        self.editingAboutField = false
    }
    
    /// This method saves the context
    private func saveContext() {
        DispatchQueue.main.async {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
