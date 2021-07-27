//
//  DetailView2.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 11/07/2021.
//

import SwiftUI

struct DetailView: View {
    // Properties
    @State var newTextData: String                              = ""
    @State var aboutText: String                                = ""
    @State var didSetNotification: Bool                         = false
    @State var showingFavouriteAlert: Bool                      = false
    @State var editingAboutField: Bool                          = false
    @State var containsCustomImage: Bool                        = false
    @State var showingSheet: Bool                               = false
    @State var showingTextFieldAlert: Bool                      = false
    @State var notificationTime: String                         = ""
    @ObservedObject var person: People
    @AppStorage("accentColor") private var accentColor: String  = "Purple"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // Alert
    @State var selectedOption: EditAlertOptions                 = .name
    @State var alertTitle: String                               = ""
    @State var alertMessage: String                             = ""
    @State var alertPlaceholder: String                         = ""
    
    // Image Picker
    @State var inputImage: UIImage?
    @State var image: Image                                     = Image("Logo")
    @State var showingImagePicker: Bool                         = false
    
    // Person's Data
    @State var name: String                                     = ""
    @State var lastName: String                                 = ""
    
    var body: some View {
        ZStack {
            Background()
            
            ScrollView(.vertical) {
                // Profile Picture
                customImage(imageSize: 100)
                    .padding(.bottom, 10)
                    .accessibility(label: Text("\(LocalizedStrings.detailImage) \(person.name)"))
                
                // Name
                Text(name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                // Last Name
                Text(lastName)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                // Birthday
                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 24) {
                        Image(systemName: "gift.fill")
                            .foregroundColor(Color(accentColor))
                            .accessibility(hidden: true)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(LocalizedStrings.birthday)
                                .font(.caption)
                            Text(UserDataManager.shared.dateFormatter.string(from: person.birthDate))
                                .font(.footnote)
                        }
                        
                        Spacer()
                    }
                    .accessibility(label: Text("\(LocalizedStrings.birthday) \(person.birthday)"))
                    
                    // Zodiac Sign
                    HStack(spacing: 24) {
                        if #available(iOS 15.0, *) {
                            Image(systemName: "sun.max.circle.fill")
                                .foregroundColor(Color(accentColor))
                                .imageScale(.medium)
                                .accessibility(hidden: true)
                        } else {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(Color(accentColor))
                                .imageScale(.medium)
                                .accessibility(hidden: true)
                                .offset(x: -1)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(LocalizedStrings.zodiacSign)
                                .font(.caption)
                            Text(UserDataManager.shared.setZodiac(from: person.birthDate).string)
                                .font(.footnote)
                        }
                        
                        Spacer()
                    }
                    .accessibility(label: Text("\(LocalizedStrings.zodiacSign) \(UserDataManager.shared.setZodiac(from: person.birthDate).string)"))
                    
                    // Group
                    HStack(spacing: 24) {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(Color(accentColor))
                            .imageScale(.small)
                            .offset(x: -6)
                            .accessibility(hidden: true)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(LocalizedStrings.group)
                                .font(.caption)
                            Text(person.group)
                                .font(.footnote)
                        }
                        .offset(x: -10)
                        
                        Spacer()
                    }
                    .accessibility(label: Text("\(LocalizedStrings.group) \(person.group)"))
                    
                    // About info
                    HStack(alignment: .top, spacing: 24) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color(accentColor))
                            .offset(y: 2)
                            .accessibility(hidden: true)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(LocalizedStrings.about)
                                .font(.caption)
                            Text(person.about)
                                .font(.footnote)
                        }
                        
                        Spacer()
                    }
                    .accessibility(label: Text("\(LocalizedStrings.about) \(person.about)"))
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal)
            .font(.title2)
            
            // Alert informing about the change of the user's state about being on the favorites list
            if self.showingFavouriteAlert {
                favouriteAlert
            }
            
            // Alert for groups and name
            if self.showingTextFieldAlert {
                TextFieldAlert(text: $newTextData,
                               showingAlert: $showingTextFieldAlert,
                               title: alertTitle,
                               message: alertMessage,
                               placeholder: alertPlaceholder)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: makeToolbar)
        .onAppear(perform: assignData)
        .onChange(of: newTextData, perform: saveAndClearTextFieldData)
        .alert(isPresented: $didSetNotification) {
            Alert(title: Text(LocalizedStrings.notificationAlertTitle),
                  message: Text("\(LocalizedStrings.notificationAlertBody) \(person.name) [\(person.birthday), \(notificationTime)]."),
                  dismissButton: .default(Text("OK")))
        }
        .actionSheet(isPresented: $showingSheet, content: makeActionSheet)
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
