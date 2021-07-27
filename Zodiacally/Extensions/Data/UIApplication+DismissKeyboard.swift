//
//  UIApplication+DismissKeyboard.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 15/04/2021.
//

import SwiftUI

// Dismiss keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
