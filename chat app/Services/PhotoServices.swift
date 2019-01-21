//
//  PhotoServices.swift
//  chat app
//
//  Created by Yves Songolo on 1/20/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct PhotoServices {

    // Method to capture photo
    static func startPhotoCapture(with viewController: UIViewController){

        let picker = UIImagePickerController()
        picker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        viewController.present(picker, animated: true, completion: nil)
    }

    static func uploadImage(_ image: UIImage, to room: Room, completion: @escaping (URL?) -> Void) {
        let roomId = room.id

        guard let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storage = Storage.storage().reference()

        let ref =  storage.child(roomId).child(imageName)
        ref.putData(data, metadata: metadata) { (meta, error) in

            ref.downloadURL(completion: { (url, error) in
                if error == nil{
                    completion(url)
                }
            })
        }
    }

    /// method to upload profile pic
    static func updateProfilePicture(_ image: UIImage, completionHandler: @escaping (URL?)->()){

        guard let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completionHandler(nil)
                return
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storage = Storage.storage().reference()

        let ref =  storage.child("profilePicture").child(imageName)

        ref.putData(data, metadata: metadata) { (meta, error) in

            ref.downloadURL(completion: { (url, error) in
                if error == nil{
                    return completionHandler(url)
                }
            })
        }
    }
}
