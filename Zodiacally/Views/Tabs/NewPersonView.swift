//
//  NewPersonView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 05/07/2021.
//

import SwiftUI

struct NewPersonView: View {
    // Properties
    @State var name: String                                         = ""
    @State var birthday: Date                                       = Date()
    @State var selectedGroup: String                                = LocalizedStrings.family
    @State var about: String                                        = LocalizedStrings.aboutPerson
    @State var isFavourite: Bool                                    = false
    @State var showingBirthdayPicker: Bool                          = false
    @Binding var isVisible: Bool
    @AppStorage("groups") var groups: [String]                      = [LocalizedStrings.family,
                                                                       LocalizedStrings.friends,
                                                                       LocalizedStrings.school,
                                                                       LocalizedStrings.work]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Core Data
    @Environment(\.managedObjectContext) var viewContext
    
    // Alert
    @State var alertTitle: String                                   = ""
    @State var alertMessage: String                                 = ""
    @State var showingAlert: Bool                                   = false
    
    // Image Picker
    @State var showingImagePicker: Bool                             = false
    @State var inputImage: UIImage?
    @State var image: Image                                         = Image("Logo")
    @State var imageData: Data?
    
    init(isVisible: Binding<Bool>) {
        _isVisible = isVisible
        // Remove TextEditor Background
        UITextView.appearance().backgroundColor = .clear
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Background()
            
            GeometryReader { geom in
                ScrollView(.vertical) {
                    // Image Button
                    Button(action: { self.showingImagePicker = true }) {
                        ProfileImagePlaceholder(image: $image, inputImage: $inputImage)
                    }
                    .frame(width: 100, height: 100)
                    .shadow(radius: 10)
                    .padding(.vertical)
                    .accessibility(label: Text(LocalizedStrings.addPhotoButton))
                    
                    personForm
                        .padding(.horizontal)
                        .font(.subheadline)
                        .frame(minHeight: geom.size.height)
                }
            }
            .overlay(Color.black.opacity(showingBirthdayPicker ? 0.5 : 0).ignoresSafeArea())
            
            if self.showingBirthdayPicker {
                BirthdayPicker(birthday: $birthday, isVisible: $showingBirthdayPicker, savingAction: nil)
            }
        }
        .navigationBarTitle(LocalizedStrings.addPerson, displayMode: .large)
        .toolbar(content: makeToolbar)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .cancel())
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
