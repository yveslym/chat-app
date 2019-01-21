//
//  Message.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import MessageKit
import UIKit
import MessageUI

struct Message: Codable{
    let id: String?
    let content: String
    let created: String
    let receiver: String?
    let sender: MessageSender
    let type: String
    let isRead: Bool
    let imageURL: String?
    let audioURL: String?

    /// Function to turn native data into JSON to be sent to Firebase
    func toDictionary() ->[String: Any]{
        let data = try! JSONEncoder().encode(self)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json as! [String : Any]
    }
}

struct MessageSender: Codable{
    let phoneNumber: String
    let name: String
}

struct MessageUI{

    let message: Message
    var image: UIImage?
    var imageMediaItem: ImageMediaItem?



    init(message: Message){
        self.message = message
        image = nil


        if message.type == "photo"{
            
            imageMediaItem = ImageMediaItem.init(url: URL.init(string: message.imageURL!)!)
        }else{
            imageMediaItem = nil
        }
    }
    init(message: Message, image: UIImage){
        self.image = image
        self.message = message

        self.imageMediaItem = ImageMediaItem.init(image: image)

    }
    init(message: Message, url: URL){

        self.message = message
        self.imageMediaItem = ImageMediaItem.init(url: url)
        self.image = nil
    }

}


 class ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    init(url: URL){
        self.url = url
        placeholderImage = UIImage()
        self.size = CGSize(width: 240, height: 240)
        DispatchQueue.global().async {
            do {
                let data = try Data.init(contentsOf: url)
                 let image = UIImage.init(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            catch{
                DispatchQueue.main.async {
                     self.image = UIImage.init(named: "icons8-user")
                }

            }


        }
    }
}

extension MessageUI: MessageType {
    var messageId: String {
        return message.id ?? UUID().uuidString
    }

    var sender: Sender {
        return Sender(id: message.sender.phoneNumber, displayName: message.sender.name)
    }

    var sentDate: Date {
        return self.message.created.toDate() ?? Date()
    }

    var kind: MessageKind {

        switch self.message.type{
        case "text":
             return .text(message.content)

        case "photo":
             return .photo(imageMediaItem!)
        case "audio":
            let customContentView = AudioCustomView()
            return .custom(customContentView)
        default:
            return .text(message.content)
        }
    }
}

extension MessageUI: Comparable {
    static func < (lhs: MessageUI, rhs: MessageUI) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }

    static func == (lhs: MessageUI, rhs: MessageUI) -> Bool {

          return lhs.message.id == rhs.message.id
    }

}

extension Message: Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.created.toDate()! < rhs.created.toDate()!
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
         return lhs.id == rhs.id
    }



}
