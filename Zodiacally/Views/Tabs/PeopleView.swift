//
//  PeopleView.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/04/2021.
//

import SwiftUI

struct PeopleView: View {
    // Properties
    @State var searchBarText:       String = ""
    @State var showingFavourites:   Bool
    
    var body: some View {
        PeopleViewNavBar(view: PeopleList(showingFavourites: showingFavourites, searchBarText: $searchBarText)) { (text) in
            self.searchBarText = text
        } onCancel: {
            searchBarText = ""
        }
        .ignoresSafeArea()
    }
}
