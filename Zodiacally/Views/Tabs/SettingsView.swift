//
//  SettingsView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 06/04/2021.
//

import SwiftUI

struct SettingsView: View {
    // Properties
    @State var showingNameAlert: Bool                                       = false
    @State var showingGroups: Bool                                          = false
    @State var showingColors: Bool                                          = false
    @State var showingAlert: Bool                                           = false
    @State var showingBirthdayPicker: Bool                                  = false
    @State var alert: Alert                                                 = Alert(title: Text(""))
    @State private var birthDate: Date                                      = Date()
    @AppStorage("userContainsCustomImage") var containsCustomImage: Bool    = false
    @AppStorage("userName") var name: String                                = ""
    @AppStorage("userBirthday") var birthday: String                        = ""
    @AppStorage("userAbout") var about: String                              = ""
    @AppStorage("userZodiac") var zodiacSign: String                        = ""
    @AppStorage("accentColor") var accentColor: String                      = "Purple"
    
    let appVersion                                                          = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let top                                                                 = UIApplication.shared.windows.first?.safeAreaInsets.top
            
    // Image Picker
    @State var showingImagePicker: Bool                                     = false
    @State var inputImage: UIImage?
    @State var image: Image                                                 = Image("Logo")
    @AppStorage("userImage") var imageData: Data?
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                
                VStack(alignment: .leading) {
                    // Image
                    profileImage
                        .accessibility(label: Text(LocalizedStrings.yourProfileImage))
                    
                    // User's Data Form
                    Form {
                        // Informations Section
                        userDataSection
                        
                        // App Settings
                        settingsSection
                    }
                    
                    Spacer()
                }
                .overlay(Color.black.opacity(showingBirthdayPicker ? 0.5 : 0))
                .ignoresSafeArea()
                
                if self.showingNameAlert {
                    TextFieldAlert(text: $name,
                                   showingAlert: $showingNameAlert,
                                   title: LocalizedStrings.changeNameTitle,
                                   message: LocalizedStrings.changeNameBody,
                                   placeholder: LocalizedStrings.changeNamePlaceholder)
                }
                
                if self.showingBirthdayPicker {
                    BirthdayPicker(birthday: $birthDate, isVisible: $showingBirthdayPicker) {
                        self.birthday = UserDataManager.shared.dateFormatter.string(from: birthDate)
                        self.zodiacSign = UserDataManager.shared.setZodiac(from: birthDate).string
                        self.showingBirthdayPicker = false
                    }
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showingAlert) { alert }
            .onAppear {
                if let newDate = UserDataManager.shared.dateFormatter.date(from: birthday) {
                    self.birthDate = newDate
                    self.birthday = UserDataManager.shared.dateFormatter.string(from: newDate)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
        }
        .animation(nil)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
