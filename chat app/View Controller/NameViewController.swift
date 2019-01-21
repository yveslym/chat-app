//
//  NameViewController.swift
//  chat app
//
//  Created by Yves Songolo on 1/14/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

class NameViewController: UIViewController {

    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var profilePicture: UIImageView!
    var profilePictureURL: String?

    var phoneNumber: String!
    var token: String!
    var deviceToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(takePicture(_:)))

        profilePicture.addGestureRecognizer(gesture)
        profilePicture.isUserInteractionEnabled = true
        nextButton.newLayerColor = .primary
    }

    @objc func takePicture(_ sender: UITapGestureRecognizer){
        print("tap")

        PhotoServices.startPhotoCapture(with: self)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {

        let user = User.init(firstName: firstname.text ?? "", lastName: lastname.text!, phoneNumber: phoneNumber, deviceToken: deviceToken, facebbokAuthToken: token, profilePictureURL: profilePictureURL)


        UserService.create(user: user) { (user, error) in
            if let user = user {
                User.setCurrentUser(user: user, writeToUserDefaults: true)
               self.performSegue(withIdentifier: "mainpage", sender: nil)
            }
        }
    }
}

extension NameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

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
                    PhotoServices.updateProfilePicture(image, completionHandler: { (url) in
                       self.setProfileImage(url: url)
                    })
            }
        } else if let image = info[.originalImage] as? UIImage {

            PhotoServices.updateProfilePicture(image, completionHandler: { (url) in
                self.setProfileImage(url: url)
            })
        }
    }

    private func setProfileImage (url: URL?){
        if let url = url{
            self.profilePictureURL = url.absoluteString
            self.profilePicture.kf.indicatorType = .activity
            self.profilePicture.kf.setImage(with: url)
        }
        else{
            self.presentAlert(title: "Error", message: "Couldn't upload image")
        }
    }
}
