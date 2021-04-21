//
//  GreetingSlide2.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/04/2021.
//

import SwiftUI

struct GreetingSlide2: View {
    // Properties
    @ObservedObject private var keyboard                    = KeyboardResponder()
    @AppStorage("userName") private var name: String        = ""
    @AppStorage("userAbout") private var about: String      = "I am..."
    @State private var birthday: Date                       = Date()
    
    // Image Picker
    @State private var showingImagePicker: Bool             = false
    @State private var inputImage: UIImage?
    @State private var image: Image                         = Image(systemName: "person.circle")
    @AppStorage("userImage") private var imageData: Data?
    
    /* ---------- Body ---------- */
    var body: some View {
        let userDataManager                                 = UserDataManager()
        let zodiacSign: String                              = userDataManager.setZodiac(from: birthday)
        
        VStack {
            VStack {
                VStack {
                    // Title and Subtitle
                    Text("Introduce Yourself")
                        .font(.largeTitle)
                    Text("It's important to remember about your birthday as well!")
                        .font(.title3)
                }
                .padding(.bottom)
                .blur(radius: keyboard.currentHeight)
                
                Spacer()
                    .frame(height: 25)
                
                VStack {
                    // Image Button
                    Button(action: { self.showingImagePicker = true }) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .foregroundColor(Color(.label))
                            .overlay(
                                Circle()
                                    .strokeBorder(Color(.label), lineWidth: 5)
                            )
                    }
                    .frame(width: 175, height: 175)
                    
                    // Name TextField
                    TextField("Name", text: $name)
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .padding(.bottom)
                    
                    // Birthday DatePicker
                    VStack(alignment: .leading, spacing: 30) {
                        DisclosureGroup("Birthday:") {
                            DatePicker("", selection: $birthday, displayedComponents: [.date])
                                .datePickerStyle(WheelDatePickerStyle())
                        }
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        
                        // Zodiac Sign
                        HStack {
                            Text("Zodiac sign:")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                            Spacer()
                            Text(zodiacSign)
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 30)
                
                // About TextEditor
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        // About Title
                        Text("About")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                        
                        Spacer()
                        
                        // Dismiss keyboard button
                        if keyboard.currentHeight != 0 {
                            Button("Dismiss") {
                                UIApplication.shared.endEditing()
                            }
                        }
                    }
                    
                    // About Text Editor
                    TextEditor(text: $about)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(height: UIScreen.main.bounds.height / 12)
                        .cornerRadius(15)
                        .shadow(color: Color(.label).opacity(0.5), radius: keyboard.currentHeight)
                }
                .padding(.bottom)
                
                Spacer()
                
                // Next Slide
                HStack {
                    Spacer()
                    NavigationLink(destination: GreetingSlide3()) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 50))
                            .foregroundColor(Color(.label))
                    }
                }
            }
            .multilineTextAlignment(.center)
            .padding()
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
        .onChange(of: birthday) { _ in
            let defaults = UserDefaults.standard
            defaults.set(userDataManager.dateFormatter.string(from: birthday), forKey: "userBirthday")
            defaults.set(userDataManager.setZodiac(from: birthday), forKey: "userZodiac")
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .offset(y: -self.keyboard.currentHeight * 0.25)
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    private func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.imageData = imageData
        self.image = Image(uiImage: inputImage)
        
        UserDefaults.standard.set(self.imageData, forKey: "userImage")
    }
}
