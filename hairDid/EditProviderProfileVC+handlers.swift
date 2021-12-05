//
//  EditProviderProfileVC+handlers.swift
//  hairDid
//
//  Created by Atlanta Brown on 12/2/21.
//

import UIKit
import Firebase
import FirebaseDatabase

extension EditProviderProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectGalleryImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
        // will upload into db, then fill in home page with this
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info [UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectedImageFromPicker = editedImage
            print("MY EDITED IMAGE \(editedImage)")
        } else if let originalImage =
            info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            print("info")
            selectedImageFromPicker = originalImage
                print("MY original IMAGE \(originalImage)")
        }
        
        if let selectedImage = selectedImageFromPicker {
            // we wanna upload it into firebase cloud right here
            saveInfoInsideStorage(selectedImage: selectedImage)
        }
        
        // give the user a success message
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelledPicker")
        dismiss(animated: true, completion: nil)
    }
    
    func saveInfoInsideStorage(selectedImage: UIImage) {
        //let storageRef = Storage.storage().reference().child("myImage.png")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("myImage.png")
        let storageProfileRef = storageRef.child(uid)
        
        // upload photo into stoage
        if let uploadData = selectedImage.pngData() {
            storageProfileRef.putData(uploadData, metadata: nil) { metadata, error in
                if error != nil {
                    print(error)
                    return
                }

                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"

                // update URL to image in db
                storageProfileRef.downloadURL (completion: {(url, error) in
                    if let metaImageURL = url?.absoluteString {
                        print(metaImageURL)
                        let ref = Database.database().reference()
                        ref.child("users/\(uid)/gallery").setValue(metaImageURL)
                    }
                })
            }
        }
    }
    
}
