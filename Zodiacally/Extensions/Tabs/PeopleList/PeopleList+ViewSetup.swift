//
//  PeopleList+ViewSetup.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/07/2021.
//

import SwiftUI

// MARK: - View Setup
extension PeopleList {
    /// This method setups the View.
    func setupView() {
        assignImage()
        prepareList()
    }
    
    // This method checks if UIImage can be created from the Binary Data and then assigns an image to a variable.
    private func assignImage() {
        if let uiImage = UIImage(data: imageData) {
            image = Image(uiImage: uiImage)
        }
    }
    
    /// This method setups the list (clears the background, separators, etc.)
    private func prepareList() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .none
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().bounds = UIScreen.main.bounds
        UITableViewCell.appearance().backgroundColor = .clear
    }
}
