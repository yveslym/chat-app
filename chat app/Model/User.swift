//
//  User.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
struct User: Codable{
    let firstName: String
    let lastName: String
    let phoneNumber: String?
    let deviceToken: String?
    let facebbokAuthToken: String
    let profilePictureURL: String?
   



    private static var _current: User?
    static var current: User?{

        // check if user exist
        if let currentUser = _current{
            return currentUser
        }else{
            // decode into user
            guard let data = UserDefaults.standard.value(forKey: "current") as? Data else {return nil}

            do{
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
            }
            catch{
                return nil
            }
            //return user or nil

        }
    }




    /// Function to set and save the current user of the app to UserDefaults
    static func setCurrentUser(user: User, writeToUserDefaults: Bool = false){

        if writeToUserDefaults{
            if let data = try? JSONEncoder().encode(user){
                UserDefaults.standard.set(data, forKey: "current")
            }
        }
        _current = user
    }

    /// Function to turn native data into JSON to be sent to Firebase
    func toDictionary() ->[String: Any]{
        let data = try! JSONEncoder().encode(self)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json as! [String : Any]
    }
}

/// enum that describe how the show service will be done
enum ShowUserArgument{

    case allFriend, singleUser(phoneNumber: String), currentUser
}

