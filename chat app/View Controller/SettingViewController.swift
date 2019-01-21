//
//  SettingViewController.swift
//  chat app
//
//  Created by Yves Songolo on 1/20/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import Kingfisher

class SettingViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!


    var user: User!{
        didSet{
            DispatchQueue.main.async {
                self.reloadVIew(user: self.user)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadVIew()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserProfile()

    }
    
    func fetchUserProfile(){

        UserService.show(type: .currentUser) { (response) in
            if let user = response as? User {
                self.user = user
            }
        }
    }

    func reloadVIew(user: User? = nil){

        if let user = user{
            fullName.text = user.firstName + " " + user.lastName
            phoneNumber.text = user.phoneNumber


            if let imageUrl = user.profilePictureURL{
            if let url = URL.init(string: imageUrl) {
            profileImage.kf.indicatorType = .activity
            profileImage.kf.setImage(with: url)
                
                }
            }
        }
        else{
            fullName.text = (User.current?.firstName)! + " " + User.current!.lastName
            phoneNumber.text = User.current!.phoneNumber
            profileImage.setIcon(icon: .fontAwesomeSolid(.userEdit))
        }
        
    }

}
