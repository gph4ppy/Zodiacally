//
//  SearchBarCoordinator.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 17/04/2021.
//

import SwiftUI

class SearchBarCoordinator: NSObject, UISearchBarDelegate {
    let parent: PeopleViewNavBar
    
    init(_ parent: PeopleViewNavBar) {
        self.parent = parent
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.parent.onSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.parent.onCancel()
    }
}
