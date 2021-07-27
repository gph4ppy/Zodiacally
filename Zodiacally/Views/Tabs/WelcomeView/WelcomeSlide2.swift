//
//  WelcomeSlide2.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 04/07/2021.
//

import SwiftUI

struct WelcomeSlide2: View {
    // Properties
    @State var birthday: Date                                               = Date()
    @State var showingBirthdayPicker: Bool                                  = false
    @State var didTapNextSlide: Bool                                        = false
    @State var didChangeDate: Bool                                          = false
    @AppStorage("userName") private var name: String                        = ""
    @AppStorage("userAbout") private var about: String                      = LocalizedStrings.iAm
    @AppStorage("userBirthday") var birthdayString: String                  = ""
    @AppStorage("userZodiac") var zodiacSign: String                        = ""
    @AppStorage("userContainsCustomImage") var containsCustomImage: Bool    = false
    
    // Image Picker
    @State private var showingImagePicker: Bool                             = false
    @State var image: Image                                                 = Image("Logo")
    @State var inputImage: UIImage?
    @AppStorage("userImage") var imageData: Data?
    
    init() {
        // Remove TextEditor Background
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Background()
            
            GeometryReader { geom in
                ScrollView(.vertical) {
                    VStack(spacing: 10) {
                        // Title and Subtitle
                        Text(LocalizedStrings.welcomeTitle2)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(.top)
                        Text(LocalizedStrings.welcomeSubtitle2)
                            .font(.headline)
                            .padding([.bottom, .horizontal])
                            .multilineTextAlignment(.center)
                        
                        // Image Button
                        Button(action: { self.showingImagePicker = true }) {
                            ProfileImagePlaceholder(image: $image, inputImage: $inputImage)
                        }
                        .frame(width: 100, height: 100)
                        .shadow(radius: 10)
                        .padding(.vertical)
                        .accessibility(label: Text(LocalizedStrings.addPhotoButton))
                        
                        VStack(alignment: .leading) {
                            // Name TextField
                            TextField(LocalizedStrings.name, text: $name)
                                .font(.title3)
                            
                            Divider()
                            
                            // Birthday DatePicker
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
                                Text(zodiacSign)
                            }
                            
                            Divider()
                            
                            // About
                            Text(LocalizedStrings.aboutMe)
                            TextEditor(text: $about)
                                .foregroundColor(.gray)
                                .offset(x: -4, y: -15)
                        }
                        .padding(.horizontal)
                        .font(.subheadline)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: WelcomeSlide3(), isActive: $didTapNextSlide) {
                                Button {
                                    self.containsCustomImage = inputImage == nil ? false : true
                                    self.zodiacSign = didChangeDate ? zodiacSign : ""
                                    self.didTapNextSlide = true
                                } label: {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color(.label))
                                }

                            }
                        }
                        .padding([.trailing, .bottom, .top])
                        .accessibility(label: Text(LocalizedStrings.nextWelcomeSlide))
                    }
                }
                .frame(minHeight: geom.size.height)
                .overlay(Color.black.opacity(showingBirthdayPicker ? 0.5 : 0).ignoresSafeArea())
                
                if self.showingBirthdayPicker {
                    BirthdayPicker(birthday: $birthday, isVisible: $showingBirthdayPicker, savingAction: nil)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { self.zodiacSign = UserDataManager.shared.setZodiac(from: birthday).symbol }
        .onChange(of: birthday) { newDate in
            self.didChangeDate = true
            self.zodiacSign = UserDataManager.shared.setZodiac(from: birthday).symbol
            saveBirthdayData(from: newDate)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
