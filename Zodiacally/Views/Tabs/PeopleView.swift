//
//  PeopleView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/04/2021.
//

import SwiftUI

struct PeopleView: View {
    @State var searchBarText: String                            = ""
    @State var showingFavourites: Bool
    
    var body: some View {
        PeopleViewNavBar(view: PeopleTab(showingFavourites: showingFavourites, searchBarText: $searchBarText)) { (text) in
            self.searchBarText = text
        } onCancel: {
            searchBarText = ""
        }
        .ignoresSafeArea()
    }
}

struct PeopleTab: View {
    // Properties
    @AppStorage("userName") private var name: String            = ""
    @AppStorage("userImage") private var imageData: Data        = Data()
    @State private var image: Image                             = Image(systemName: "person.circle")
    @State var showingFavourites: Bool
    @Binding var searchBarText: String
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [
                    NSSortDescriptor(keyPath: \People.displayOrder, ascending: true),
                    NSSortDescriptor(keyPath: \People.name, ascending: true)],
                  animation: .default)
    private var people: FetchedResults<People>
    
    /* ---------- Body ---------- */
    var body: some View {
        List {
            // People Card
            ForEach(people.filter({ searchBarText.isEmpty || $0.name.localizedStandardContains(searchBarText) }), id: \.self) { person in
                
                // Check which page is selected:
                // 1 - People (everyone)
                // 2 - Favourites
                if showingFavourites {
                    // Show favourites if 2nd page is selected
                    if person.isFavourite {
                        PersonCard(person: person)
                    }
                } else {
                    // Otherwise show everyone
                    PersonCard(person: person)
                }
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
        .toolbar {
            VStack {
                HStack {
                    // Add new person
                    NavigationLink(
                        destination: NewPersonView(isFavourite: showingFavourites)) {
                        Image(systemName: "plus")
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    // Edit Button
                    EditButton()
                    
                    Spacer(minLength: 50)
                    
                    // Image and name
                    HStack {
                        Text(name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: UIScreen.main.bounds.width)
            }
        }
        .navigationBarTitle(showingFavourites ? "Favorite people" : "People")
        .animation(nil)
        .onAppear {
            if let uiImage = UIImage(data: imageData) {
                image = Image(uiImage: uiImage)
            }
        }
    }
    
    /// This method moves object at another index
    /// - Parameters:
    ///   - source: where is that object now
    ///   - destination: where it will be placed (on which index)
    func move(from source: IndexSet, to destination: Int) {
        DispatchQueue.main.async {
            var revisedItems: [People] = people.map{ $0 }
            revisedItems.move(fromOffsets: source, toOffset: destination)
            
            for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
                revisedItems[reverseIndex].displayOrder = Int16(reverseIndex)
            }
            
            saveContext()
        }
    }
    
    /// This method removes person from the context
    /// - Parameter offsets: on which index is the person that will be removed
    func delete(at offsets: IndexSet) {
        DispatchQueue.main.async {
            withAnimation {
                offsets.map { people[$0] }.forEach(viewContext.delete)
            }
            
            saveContext()
        }
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
