//
//  TextFieldAlertCoordinator.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 09/04/2021.
//

import SwiftUI

class TextFieldAlertCoordinator: NSObject, UITextFieldDelegate {
    // Properties
    let parent: TextFieldAlert
    var alert: UIAlertController?
    
    init(_ parent: TextFieldAlert) {
        self.parent = parent
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            self.parent.text = text.replacingCharacters(in: range, with: string)
        } else {
            self.parent.text = ""
        }
        
        return true
    }
}
