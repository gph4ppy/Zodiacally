//
//  TextFieldAlert.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 09/04/2021.
//

import SwiftUI

struct TextFieldAlert: UIViewControllerRepresentable {
    // Properties
    @Binding var text: String
    @Binding var showingAlert: Bool
    
    var title: String
    var message: String
    var placeholder: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewController {
        return UIViewController()
    }
    
    func makeCoordinator() -> TextFieldAlertCoordinator {
        TextFieldAlertCoordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TextFieldAlert>) {
        guard context.coordinator.alert == nil else { return }

        if self.showingAlert {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = ac

            ac.addTextField { textField in
                textField.placeholder = placeholder
                textField.text = self.text
                textField.delegate = context.coordinator
            }
            
            ac.textFields?[0].clearButtonMode = .always

            ac.addAction(UIAlertAction(title: LocalizedStrings.cancel, style: .destructive) { _ in
                ac.dismiss(animated: true) {
                    self.showingAlert = false
                }
            })

            ac.addAction(UIAlertAction(title: LocalizedStrings.save, style: .default) { _ in
                if let textField = ac.textFields?[0], let text = textField.text {
                    self.text = text
                }

                ac.dismiss(animated: true) {
                    self.showingAlert = false
                }
            })

            DispatchQueue.main.async {
                uiViewController.present(ac, animated: true) {
                    self.showingAlert = false
                    context.coordinator.alert = nil
                }
            }
        }
    }
}
