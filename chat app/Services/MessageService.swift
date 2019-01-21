//
//  MessageService.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation

struct MessageService{

    /* THIS METHOD CREATES A SINGLE USER OBJECT AND STORES IT IN THE DATABASE
     @param roomId: the id of the room to create the message
     @param completion -> Any: The single user obejct to be returned after the method call
     */
    static func create(roomId: String,message: Message){

        let referencce = Constant.roomRef().child(roomId).child("messages").child(message.id!)
        referencce.setValue(message.toDictionary())
    }

    /*
     THIS METHOD OBSERVE A SINGLE ROOM WHEN A NEW MESSAGE IS SENT
     @param roomId: the id of the room where the message will be observe
      @param completion -> Message: The single message obejct to be returned after the method call

     */
    static func observeMessage(roomId: String, completionHandler: @escaping(Message)->()){

        let ref = Constant.roomRef().child(roomId).child("messages")

        ref.observe(.childAdded) { (snapshot) in
            if snapshot.exists(){
                do{
                    let message = try JSONDecoder().decode(Message.self, withJSONObject: snapshot.value as Any, options: [])
                    return completionHandler(message)
                }
                catch{
                    print("could not decode message")
                }
            }
        }
    }
}
