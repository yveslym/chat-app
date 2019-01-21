//
//  RoomServices.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase

struct RoomService{

    /* THIS METHOD CREATES A SINGLE ROOM OBJECT AND STORES IT IN THE DATABASE
     @param room : The room object to be created
     @param message: the message sent by the user that goes along with the room
     -> String: return a error message
     */
    static func create(room: Room, message: Message){

        let reference = Constant.roomRef().child(room.id)

        reference.setValue(room.toDictionary()) { (error, ref) in

            MessageService.create(roomId: room.id, message: message)
        }
    }

    /* THIS METHOD RETRIEVE USER FROM THE DATABASE
     @param completion -> User: The single user obejct to be returned after the method call
     */
    static func show(completionHandler: @escaping([Room]?)->()){
        let dispatchGroup = DispatchGroup()
        var rooms = [Room]()

        showSavedRoom { (savedRoom) in

            savedRoom.forEach({ (room) in

                dispatchGroup.enter()

                 let reference = Constant.roomRef().child(room.id)

                reference.observeSingleEvent(of: .value, with: { (snapshot) in
                  let room = decodeRoom(snapshot: snapshot)
                    if let room = room{
                        rooms.append(room)
                    }
                     dispatchGroup.leave()
                })

            })
            dispatchGroup.notify(queue: .global()) {

                return completionHandler(rooms)
            }
        }


    }


fileprivate static func showSavedRoom(completionHandler: @escaping([SavedRoom])->()){
    var savedrooms = [SavedRoom]()

    let reference = Constant.currentUserRef().child("room")
    reference.observeSingleEvent(of: .value) { (snapshot) in

        for child in snapshot.children{
            let snap = child as! DataSnapshot
            do{
                let room = try JSONDecoder().decode(SavedRoom.self, withJSONObject: snap.value as Any, options: [])
                savedrooms.append(room)
            }
            catch{

            }
        }
        return completionHandler(savedrooms)
    }
    }

    static func saveRoom(room: Room){
        let roomToSave = SavedRoom.init(room: room)
        let reference = Constant.currentUserRef().child("room").child(room.id)
        var user = User.current
        
        

        User.setCurrentUser(user: user!, writeToUserDefaults: true)
        reference.setValue(roomToSave.toDictionary())
    }

    private static func showSingleRoom( roomId: String,completionHandler: @escaping(Room?)->()){

        let reference = Constant.roomRef().child(roomId)

        reference.observeSingleEvent(of: .value) { (snapshot) in

            if snapshot.exists(){
                do{
                    let room = try JSONDecoder().decode(Room.self, withJSONObject: snapshot.value as Any, options: [])
                    return completionHandler(room)

                }
                catch{

                }
            }
        }
    }

    fileprivate static func decodeRoom(snapshot: DataSnapshot) -> Room?{
        do{
            let value = snapshot.value as? [String: Any]
            let id = value?["id"] as? String
            let memberData = value?["member"] as! [Any]

            let member = try JSONDecoder().decode([User].self, withJSONObject: memberData, options: [])

            let messageJson = value?["messages"] as! [String: Any]
            var messages = [Message]()

            for (_ , messageData) in messageJson{
                let message = try JSONDecoder().decode(Message.self, withJSONObject: messageData as Any, options: [])
                messages.append(message)
            }



            let room = Room.init(id: id!, messages: messages, member: member)
           return room
        }
        catch{
            return nil
        }
    }

    static func observeRoomOnNewMessage(room: Room, completionHandler: @escaping (Room)->()){


        var observedRoom : Room!


            let reference = Constant.roomRef().child(room.id)
            reference.observe(.value, with: { (snapshot) in

                if snapshot.exists(){
                    observedRoom = decodeRoom(snapshot: snapshot)
                    return completionHandler(observedRoom)
                }

            })



    }

    

    static func delete(){

    }
}
