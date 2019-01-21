//
//  Constant.swift
//  chat app
//
//  Created by Yves Songolo on 1/14/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct Constant{

     var userRef = Database.database().reference().child("Users")


    static func currentUserRef() -> DatabaseReference{
        return Database.database().reference().child("Users").child(User.current!.phoneNumber!)
    }
    static func currentUserFriendsRef() -> DatabaseReference{
        return Database.database().reference().child("Users").child(User.current!.phoneNumber!).child("friends")
    }
    static func userWithIdReference(phoneNumber: String)-> DatabaseReference{
        return Database.database().reference().child("Users").child(phoneNumber)
    }
    static func userRef() -> DatabaseReference{
        return Database.database().reference().child("Users")
    }

    static func roomRef() -> DatabaseReference{
        return Database.database().reference().child("Rooms")
    }
    
}
