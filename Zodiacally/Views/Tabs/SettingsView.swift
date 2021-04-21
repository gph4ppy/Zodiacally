//
//  SettingsView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 06/04/2021.
//

import SwiftUI

struct SettingsView: View {
    // Properties
    @AppStorage("userName") private var name: String                = ""
    @AppStorage("userBirthday") private var birthday: String        = ""
    @AppStorage("userAbout") private var about: String              = ""
    @AppStorage("userZodiac") private var zodiacSign: String        = ""
    @AppStorage("accentColor") private var accentColor: String      = "Purple"
    @State private var showingAlert: Bool                           = false
    @State private var showingGroups: Bool                          = false
    let accentColors                                                = ["Red", "Green", "Blue", "Pink", "Purple", "Yellow"]
    
    let appVersion                                                  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let top                                                         = UIApplication.shared.windows.first?.safeAreaInsets.top
    
    // Image Picker
    @State private var showingImagePicker: Bool                     = false
    @State private var inputImage: UIImage?
    @State private var image: Image                                 = Image(systemName: "person.circle")
    @AppStorage("userImage") private var imageData: Data?
    
    /* ---------- Body ---------- */
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    // Top Area
                    Rectangle()
                        .fill(Color(.label).opacity(0.1))
                        .overlay(
                            // Image Button
                            VStack {
                                Spacer()
                                Button(action: { self.showingImagePicker = true }, label: {
                                    if imageData == nil {
                                        image
                                            .resizable()
                                            .foregroundColor(Color(.label))
                                            .aspectRatio(contentMode: .fill)
                                    } else {
                                        let uiImage = UIImage(data: imageData!)
                                        Image(uiImage: uiImage ?? UIImage(systemName: "person.circle")!.withTintColor(.label))
                                            .resizable()
                                    }
                                })
                                .frame(width: 125, height: 125)
                                .clipShape(Circle())
                                .padding(8)
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color(.label), lineWidth: 5)
                                )
                                .shadow(color: Color(.label).opacity(0.5), radius: 1)
                                
                                Spacer()
                            }
                        )
                        .ignoresSafeArea()
                        .frame(height: 200)
                    
                    Divider()
                    
                    Form {
                        // Informations Section
                        Section(header: Text("Informations").foregroundColor(.gray)) {
                            // Name
                            HStack {
                                Text("Name")
                                Spacer(minLength: 50)
                                Text(name)
                                    .foregroundColor(.gray)
                            }
                            
                            // Birthday
                            HStack {
                                Text("Birthday")
                                Spacer()
                                Text(birthday)
                                    .foregroundColor(.gray)
                            }
                            
                            // Zodiac Sign
                            HStack {
                                Text("Zodiac Sign")
                                Spacer()
                                Text(zodiacSign)
                            }
                            
                            // About
                            if !about.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("About Me")
                                        .padding(.bottom, 1)
                                    Text(about)
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        
                        // App Settings
                        Section(header: Text("Settings").foregroundColor(.gray)) {
                            // Change Name
                            Button("Change name") {
                                self.showingAlert = true
                            }
                            
                            // Change birthday
                            Button("Change birthday") {
                                showDatePickerAlert()
                            }
                            
                            // Edit about
                            Button("Edit about") {
                                showTextViewAlert()
                            }
                            
                            ZStack {
                                // Accent Color Picker
                                Picker("", selection: $accentColor) {
                                    ForEach(accentColors, id: \.self) { color in
                                        HStack(spacing: 5) {
                                            Color(color)
                                                .frame(width: 25, height: 25)
                                                .clipShape(Circle())
                                                .padding(.trailing, 5)
                                            Text(color)
                                        }
                                    }
                                }
                                .hidden()
                                .frame(height: 0)
                                Button(action: {}) {
                                    HStack {
                                        Text("Accent color")
                                        
                                        Spacer()
                                        
                                        Color(accentColor)
                                            .frame(width: 25, height: 25)
                                            .clipShape(Circle())
                                        Text(accentColor)
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
                                
                                Button("Edit groups") {
                                    self.showingGroups = true
                                }
                            }
                            
                            // Clear Notifications Button
                            Button("Clear notifications") {
                                let center = UNUserNotificationCenter.current()
                                center.removeAllPendingNotificationRequests()
                            }
                            
                            // App Version
                            HStack {
                                Text("Version")
                                Spacer()
                                Text(appVersion ?? "⚠️")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                
                // New name alert
                if self.showingAlert {
                    TextFieldAlert(text: $name, showingAlert: $showingAlert, title: "Change Name", message: "Your new name is", placeholder: "Your Name")
                }
            }
            .navigationBarHidden(true)
        }
        .animation(nil)
        .sheet(isPresented: self.$showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    private func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.imageData = imageData
        self.image = Image(uiImage: inputImage)
    }
    
    /// This method shows the TextView alert and saves it's content as a user's about info
    func showTextViewAlert() {
        let alertVC = UIAlertController(title: "Edit About", message: nil, preferredStyle: .alert)
        let textView: UITextView = UITextView()
        textView.text = about
        textView.layer.cornerRadius = 15
        textView.translatesAutoresizingMaskIntoConstraints = false
        
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
        alertVC.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            if let aboutString = textView.text {
                self.about = aboutString
            }
        })
        
        // Cancel Action
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present Sheet
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
    /// This method shows the datepicker alert and saves the date as a user's birthday
    func showDatePickerAlert() {
        let device = UIDevice.current.userInterfaceIdiom
        let alertVC = UIAlertController(title: "Choose birthday",
                                        message: nil,
                                        preferredStyle: device == .pad ? .alert : .actionSheet)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        alertVC.view.addSubview(datePicker)
        
        // Activate Anchors
        NSLayoutConstraint.activate([
            // Vertical Anchors
            datePicker.topAnchor.constraint(equalTo: alertVC.view.topAnchor, constant: 0),
            datePicker.bottomAnchor.constraint(equalTo: alertVC.view.bottomAnchor, constant: -100),
            
            // Horizontal Anchors
            datePicker.leadingAnchor.constraint(equalTo: alertVC.view.leadingAnchor, constant: 0),
            datePicker.trailingAnchor.constraint(equalTo: alertVC.view.trailingAnchor, constant: 0)
        ])
        
        // Set Sheet Height
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 400)
        alertVC.view.addConstraint(height)
        
        // Save Action
        alertVC.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let userDataManager = UserDataManager()
            let date = datePicker.date
            
            birthday = userDataManager.dateFormatter.string(from: date)
            zodiacSign = userDataManager.setZodiac(from: date)
        })
        
        // Cancel Action
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present Sheet
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
}
