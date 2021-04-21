//
//  NewPersonView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI

struct NewPersonView: View {
    // Properties
    @AppStorage("groups") private var groups: [String]      = ["Family", "Friends", "School", "Work"]
    @ObservedObject private var keyboard                    = KeyboardResponder()
    @State private var name: String                         = ""
    @State private var birthday: Date                       = Date()
    @State private var selectedGroup: String                = "Family"
    @State private var about: String                        = "This person is..."
    let isFavourite: Bool
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // Alert
    @State private var alertTitle: String                   = ""
    @State private var alertMessage: String                 = ""
    @State private var showingAlert: Bool                   = false
    
    // Image Picker
    @State private var showingImagePicker: Bool             = false
    @State private var inputImage: UIImage?
    @State private var image: Image                         = Image(systemName: "person.circle")
    @State private var imageData: Data?
    
    /* ---------- Body ---------- */
    var body: some View {
        let userDataManager = UserDataManager()
        let zodiacSign: String = userDataManager.setZodiac(from: birthday)
        let person = Person(id: UUID().uuidString,
                            name: name,
                            birthday: userDataManager.dateFormatter.string(from: birthday),
                            zodiacSign: zodiacSign, group: selectedGroup,
                            isFavourite: isFavourite,
                            about: about,
                            image: imageData ?? Data(),
                            birthDate: birthday,
                            didSetNotification: false)
        
        Form {
            VStack {
                // Select image for the new user
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
                        .shadow(color: Color(.label).opacity(0.6), radius: 5)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 150, height: 150)
                .padding(.top)
                
                // Name Text Field
                TextField("Name", text: $name)
                    .frame(height: 44)
                    .font(.system(size: 35, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .disableAutocorrection(true)
                
                Divider()
                    .padding(.bottom)
                
                // Birthday Picker
                // Outside VStack to silence the warning about constraints (even though it worked fine)
                DisclosureGroup("Birthday:") {
                    DatePicker("", selection: $birthday, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                }
                .font(.system(size: 20, weight: .semibold, design: .default))
                
                Spacer()
                    .frame(height: 30)
                
                // New Person Data
                VStack(alignment: .leading, spacing: 30) {
                    // Zodiac Sign
                    HStack {
                        Text("Zodiac sign:")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                        Spacer()
                        Text(zodiacSign)
                    }
                    
                    // Group
                    HStack {
                        Text("Group:")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                        Text(selectedGroup)
                        Spacer()
                        Picker("Select", selection: $selectedGroup) {
                            ForEach(groups, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Informations about new person
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("About")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                            
                            Spacer()
                            
                            if keyboard.currentHeight != 0 {
                                Button(action: UIApplication.shared.endEditing) {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal)
                            }
                        }
                        
                        TextEditor(text: $about)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom)
                }
            }
            .offset(y: -self.keyboard.currentHeight * 0.9)
        }
        .font(.system(size: 20))
        .navigationBarTitle("Add new person")
        .toolbar {
            Button("Save") {
                savePerson(person)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    /// This method saves the person into the context
    /// - Parameter person: person model, which contains the data to save
    private func savePerson(_ person: Person) {
        // Check if name is empty
        if name.isEmpty {
            // Name is empty, show warning alert
            showAlert()
        } else {
            DispatchQueue.main.async {
                // Save person to context
                let newPerson = People(context: viewContext)
                
                newPerson.id = person.id
                newPerson.name = person.name
                newPerson.birthday = person.birthday
                newPerson.zodiacSign = person.zodiacSign
                newPerson.isFavourite = person.isFavourite
                newPerson.group = person.group
                newPerson.about = person.about
                newPerson.image = person.image
                newPerson.birthDate = person.birthDate
                newPerson.didSetNotification = person.didSetNotification
                
                saveContext()
                
                // Dismiss View
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    /// This method shows the alert when the user tries to save a person with an empty name
    private func showAlert() {
        DispatchQueue.main.async {
            alertTitle = "Where's the name?"
            alertMessage = "The name field must be filled"
            showingAlert = true
        }
    }
    
    /// This method loads the image into placeholder and saves the image binary data
    private func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 1.0)
        else { return }
        
        self.imageData = imageData
        self.image = Image(uiImage: inputImage)
    }
    
    /// This method saves the context
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
