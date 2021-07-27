//
//  PersonCard.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/07/2021.
//

import SwiftUI

struct PersonCard: View {
    // Properties
    @State var image: Image                         = Image("Logo")
    @State var containsCustomImage                  = false
    @Binding var isEditing: Bool
    @ObservedObject var person: People
    @Environment(\.colorScheme) var colorScheme
    let imageSize: CGFloat                          = 46.0
    
    var body: some View {
        if isEditing {
            editableCard
        } else {
            defaultCard
        }
    }
}
