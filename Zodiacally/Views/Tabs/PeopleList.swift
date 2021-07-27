//
//  PeopleList.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/07/2021.
//

import SwiftUI

struct PeopleList: View {
    // Properties
    @State var image: Image                                                 = Image("Logo")
    @State var showingNewPersonForm: Bool                                   = false
    @State var showingFavourites: Bool
    @Binding var searchBarText: String
    @AppStorage("userName") var name: String                                = ""
    @AppStorage("userImage") var imageData: Data                            = Data()
    @AppStorage("userContainsCustomImage") var containsCustomImage: Bool    = false
    @Environment(\.editMode) var editMode
    @Environment(\.colorScheme) var colorScheme
    
    // Core Data
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \People.displayOrder, ascending: true),
        NSSortDescriptor(keyPath: \People.name, ascending: true)],
                  animation: .default)
    var people: FetchedResults<People>
    
    var body: some View {
        ZStack {
            Background()
            
            GeometryReader { geom in
                List {
                    ForEach(people.filter({
                        searchBarText.isEmpty ||
                        $0.name.localizedStandardContains(searchBarText) ||
                        $0.group.localizedStandardContains(searchBarText) ||
                        $0.birthday.localizedStandardContains(searchBarText) ||
                        $0.zodiacSign.localizedStandardContains(searchBarText)
                    }), id: \.self) { person in
                        
                        // Check which page is selected:
                        // 1 - People (everyone)
                        // 2 - Favourites
                        if let isEditing = self.editMode?.wrappedValue.isEditing {
                            if showingFavourites {
                                // Show favourites if 2nd page is selected
                                if person.isFavourite {
                                    ZStack {
                                        NavigationLink(destination: DetailView(person: person)) {
                                            EmptyView()
                                        }
                                        
                                        PersonCard(isEditing: .constant(isEditing), person: person)
                                            .accessibility(label: Text("\(LocalizedStrings.cardInfo) \(person.name)"))
                                    }
                                }
                            } else {
                                // Otherwise show everyone
                                ZStack {
                                    NavigationLink(destination: DetailView(person: person)) {
                                        EmptyView()
                                    }
                                    
                                    PersonCard(isEditing: .constant(isEditing), person: person)
                                        .accessibility(label: Text("\(LocalizedStrings.cardInfo) \(person.name)"))
                                }
                            }
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                    .listRowBackground(Color.clear)
                }
                .frame(minHeight: geom.size.height)
                .frame(width: geom.size.width)
            }
        }
        .toolbar(content: makeToolbar)
        .navigationBarTitle(showingFavourites ? LocalizedStrings.favoritePeople : LocalizedStrings.people)
        .animation(nil)
        .onAppear(perform: setupView)
    }
}
