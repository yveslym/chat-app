//
//  Room.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation

struct Room: Codable{

    let id: String
    var messages: [Message]
    let member: [User]

    /// Function to turn native data into JSON to be sent to Firebase
    func toDictionary() ->[String: Any]{
        let data = try! JSONEncoder().encode(self)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json as! [String : Any]
    }
}

struct SavedRoom: Codable{
    let member: [User]
    let id: String
    init(room: Room) {
        self.id = room.id
        self.member = room.member
    }
    /// Function to turn native data into JSON to be sent to Firebase
    func toDictionary() ->[String: Any]{
        let data = try! JSONEncoder().encode(self)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json as! [String : Any]
    }
}
