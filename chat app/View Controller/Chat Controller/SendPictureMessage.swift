//
//  PictureMessageHandling.swift
//  chat app
//
//  Created by Yves Songolo on 1/18/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

import MessageInputBar
import FirebaseFirestore
import FirebaseStorage
import Photos

// MARK: Handleling send photos
extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Actions

    @objc func cameraButtonPressed() {

        PhotoServices.startPhotoCapture(with: self)
    }

    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true



        PhotoServices.uploadImage(image, to: room) { [weak self] url in
            guard let `self` = self else {
                return
            }
            self.isSendingPhoto = false

            guard let url = url else {
                return
            }

            let sender = MessageSender.init(phoneNumber: User.current!.phoneNumber!, name: User.current!.firstName + " " + User.current!.lastName)
            let message = Message.init(id: UUID().uuidString, content: "", created: Date().toString(),receiver: self.receiverNumber, sender: sender, type: "photo", isRead: false, imageURL: url.absoluteString, audioURL: nil)

            self.insertNewMessage(MessageUI.init(message: message, image: image))
            self.messagesCollectionView.scrollToBottom()

            self.save(message)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)


        if let asset = info[.phAsset] as? PHAsset {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFit,
                options: nil) { result, info in

                    guard let image = result else {
                        return
                    }

                    self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage {
            sendPhoto(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)

        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }

            completion(UIImage(data: imageData))
        }
    }
}
