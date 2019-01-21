//
//  LoginViewController.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import AccountKit
import Firebase

class LoginViewController: UIViewController {



    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var signupButton: CustomButton!
    var deviceToken: String!
    
    var accountKit: AKFAccountKit!
    var authorizationCode: String!
    var pendingViewController: AKFViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        if accountKit == nil {
            accountKit = AKFAccountKit(responseType: .accessToken)
            accountKit.requestAccount { (account, error) in
                if let phone = account?.phoneNumber{
                    print(phone)
                }
            }
        }
        loginButton.newLayerColor = .primary

    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        
          loginWithPhone()

    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        loginWithPhone()
    }

    private func getUserAccount(completion: @escaping(AKFAccount)->()){


        if accountKit == nil {
            accountKit = AKFAccountKit(responseType: .accessToken)
        }
            accountKit.requestAccount { (account, error) in
                if error == nil{
                    return completion(account!)
                }
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if accountKit?.currentAccessToken != nil {
            // if the user is already logged in, go to the main screen

        }
        else {
            // Show the login screen

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!

        self.prepareLoginViewController(loginViewController: vc)

        print ("Present login view controller")
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: AKFViewControllerDelegate{

    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
         loginViewController.enableSendToFacebook = true
        loginViewController.enableGetACall = true

        //UI Theming - Optional
        loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: UIColor.blue)
    }


    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {

        getUserAccount { (account) in

            let phoneNumber = account.phoneNumber?.stringRepresentation()

            UserService.show(type: .singleUser(phoneNumber: phoneNumber!), completionHandler: { (response) in
                if let user = response as? User {
                    // user exist, go to main page
                    User.setCurrentUser(user: user, writeToUserDefaults: true)

                    self.performSegue(withIdentifier: "mainpage", sender: nil)
                }
                else{
                    InstanceID.instanceID().instanceID { (result, error) in
                        if let error = error {
                            print("Error fetching remote instance ID: \(error)")
                        } else if let result = result {
                            print("Remote instance ID token: \(result.token)")
                            self.deviceToken = result.token

                            // go to sign up page
                            self.performSegue(withIdentifier: "gotonamepage", sender: account)
                        }
                    }
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier{
        case "gotonamepage":
            let destination = segue.destination as! NameViewController
            guard let account = sender as? AKFAccount else {return}

            destination.phoneNumber = account.phoneNumber?.stringRepresentation()
            destination.token = accountKit.currentAccessToken?.tokenString
            destination.deviceToken = deviceToken

        default: break
        }
    }

    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(viewController) did fail with error: \(error.localizedDescription)")
    }

    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
    }
}
