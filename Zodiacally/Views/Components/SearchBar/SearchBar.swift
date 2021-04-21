//
//  SearchBar.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 02/04/2021.
//

import SwiftUI

struct PeopleViewNavBar: UIViewControllerRepresentable {
    var view: PeopleTab
    
    var onSearch: (String) -> ()
    var onCancel: () -> ()
    
    init(view: PeopleTab, onSearch: @escaping (String) -> (), onCancel: @escaping () -> ()) {
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let childView = UIHostingController(rootView: view)
        let controller = UINavigationController(rootViewController: childView)
        
        // Setup NavBar
        controller.navigationBar.topItem?.title = view.showingFavourites ? "Favorite people" : "People"
        controller.navigationBar.prefersLargeTitles = true
        
        // Setup SearchBar
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = context.coordinator
        
        // SearchBar in NavBar - Search Bar behavior
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
    func makeCoordinator() -> SearchBarCoordinator {
        SearchBarCoordinator(self)
    }
}
