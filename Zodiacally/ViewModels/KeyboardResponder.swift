//
//  KeyboardResponder.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 15/04/2021.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
    var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        DispatchQueue.main.async {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                withAnimation {
                    self.currentHeight = keyboardSize.height
                }
            }
        }
    }
    @objc func keyBoardWillHide(notification: Notification) {
        DispatchQueue.main.async {
            withAnimation {
                self.currentHeight = 0
            }
        }
    }
}
