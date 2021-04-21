//
//  ImagePickerCoordinator.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 08/04/2021.
//

import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            if let uiImage = info[.editedImage] as? UIImage {
                self.parent.image = uiImage
            }
            
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
