//
//  UserService.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct UserService{

    /* THIS METHOD CREATES A SINGLE USER OBJECT AND STORES IT IN THE DATABASE
     @param user : The user object to be created
     @param completionHandler -> User: The single user obejct to be returned after the method call
     -> String: return a error message
     */
    static func create(user: User, completionHandler: @escaping (User?, String)->()){

        let reference = Constant.userRef().child(user.phoneNumber!)
        reference.setValue(user.toDictionary()) { (error, reference) in
            if error == nil{
                show(type: .singleUser(phoneNumber: reference.key!), completionHandler: { (response) in
                    guard let user = response as? User else{return completionHandler(nil, response as! String)}

                    return completionHandler(user,"")
                })
            }
            else{
            return completionHandler(nil, "could not create new user")
            }
        }
    }

    /* THIS METHOD RETRIEVE USER FROM THE DATABASE
     @param type -> ShowUserArgument: this is a enum determine either you retrieving current user, all friend or single user with id
    @param completion -> Any: The single user obejct to be returned after the method call
     */
    static func show( type: ShowUserArgument, completionHandler: @escaping(Any)->()){
        switch type{

        // retrieve all friend
        case .allFriend:

            let reference = Constant.currentUserFriendsRef()

            // retrieve list of friend phone number

            reference.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists(){
                    do{
                        var value = [String]()
                        if ((snapshot.value as? String) != nil){
                            value.append(snapshot.value as! String)
                        }
                        else {
                            let v = snapshot.value as! [Any]
                            value.append(v[1] as! String)

                        }
                        let friendsPhoneNumber = try JSONDecoder().decode([String].self, withJSONObject: value as Any, options: [])
                        
                        let dispatchGroup = DispatchGroup()

                        var friends = [User]()

                        // retrieve each friend object by their phone number

                        friendsPhoneNumber.forEach({
                            dispatchGroup.enter()
                            show(type: .singleUser(phoneNumber: $0), completionHandler: { (user) in
                                if let friend = user as? User{
                                    friends.append(friend)
                                }
                                dispatchGroup.leave()
                            })
                            dispatchGroup.notify(queue: .global(), execute: {
                                return completionHandler(friends)
                            })
                        })

                    }
                    catch{

                        return completionHandler("could't decode all user account")
                    }
                }
                else{
                    return completionHandler("user doesn't have friends")
                }
            }
        //retrive single user with id

        case .singleUser(let phoneNumber):

            let reference = Constant.userWithIdReference(phoneNumber: phoneNumber)

            reference.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists(){
                    do{
                        let user = try JSONDecoder().decode(User.self, withJSONObject: snapshot.value as Any, options: [])
                        completionHandler(user)
                    }
                    catch{
                        return completionHandler("couldn't decode user")
                    }
                }
                else{
                    return completionHandler("user does not exist")
                }
            }

        // retrieve current user

        case .currentUser:

            let reference = Constant.currentUserRef()
            reference.observeSingleEvent(of: .value) { (snapshot) in

                if snapshot.exists(){
                    do{
                        let user = try JSONDecoder().decode(User.self, withJSONObject: snapshot.value as Any, options: [])

                        return completionHandler(user)
                    }
                    catch{
                        return completionHandler("could not decode user")
                    }
                }
                else{
                    return completionHandler("user does not exist")
                }
            }
        }
    }
}
