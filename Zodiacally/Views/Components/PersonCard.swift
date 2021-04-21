//
//  PersonCard.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI

struct PersonCard: View {
    // Properties
    @State private var image: Image = Image(systemName: "person.circle")
    @ObservedObject var person: People
    
    /* ---------- Body ---------- */
    var body: some View {
        NavigationLink(destination: DetailView(person: person)) {
            HStack(spacing: 12) {
                // Person's image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .foregroundColor(Color(.label))
                
                // Person's name
                VStack(alignment: .leading, spacing: 4) {
                    Text(person.name)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    // Person's birthday
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Birthday")
                                .modifier(LabelStyle())
                            Text(person.birthday)
                                .font(.body)
                                .foregroundColor(Color(.tertiaryLabel))
                        }
                        
                        // Person's zodiac sign
                        HStack {
                            Text("Zodiac")
                                .modifier(LabelStyle())
                            Text(person.zodiacSign)
                                .font(.body)
                                .foregroundColor(Color(.tertiaryLabel))
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .lineLimit(1)
        }
        .contextMenu {
            // Copy Name
            Button(action: {
                UIPasteboard.general.string = person.name
            }) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Copy name")
                }
            }
            
            // Copy Birthday
            Button(action: {
                UIPasteboard.general.string = person.birthday
            }) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Copy birthday")
                }
            }
            
            // Copy Zodiac Sign
            Button(action: {
                UIPasteboard.general.string = person.zodiacSign
            }) {
                HStack {
                    Image(systemName: "person.2.square.stack.fill")
                    Text("Copy zodiac sign")
                }
            }
            
            // Copy informations about this person
            Button(action: {
                UIPasteboard.general.string = person.about
            }) {
                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                Text("Copy informations about")
            }
        }
        .onAppear {
            if let uiImage = UIImage(data: person.image) {
                image = Image(uiImage: uiImage)
            }
        }
    }
}
