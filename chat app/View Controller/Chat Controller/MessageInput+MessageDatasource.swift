//
//  MessageInput+MessageDatasource.swift
//  chat app
//
//  Created by Yves Songolo on 1/18/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import MessageInputBar



/// Handle message collection view data source

extension MessageViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageUI.count
    }

    func currentSender() -> Sender {
        return Sender(id: User.current!.phoneNumber!, displayName: User.current!.firstName + " " + User.current!.lastName)
    }


    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return messageUI[indexPath.section]

        
    }

    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {

        return 12
    }


}


extension MessageViewController: MessageInputBarDelegate {


    /// Method to send text messages
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {

        if room != nil{
            let member = room.member.filter({$0.phoneNumber != User.current!.phoneNumber})
            if member.count == 0{
                receiverNumber = User.current!.phoneNumber!
            }else{
                receiverNumber = member.first!.phoneNumber!
            }
        }


        let sender = MessageSender.init(phoneNumber: User.current!.phoneNumber!, name: User.current!.firstName + " " +  User.current!.lastName)

        let message = Message.init(id: UUID().uuidString, content: text, created: Date().toString(),receiver: receiverNumber, sender: sender, type: "text", isRead: false, imageURL: nil, audioURL: nil)


        if room != nil {
            DispatchQueue.global().async {
                MessageService.create(roomId: self.room.id, message: message)
            }
        }

        else{

            DispatchQueue.global().async {

                UserService.show(type: .singleUser(phoneNumber: self.receiverNumber)) { (user) in
                    if let receiver = user as? User{
                        let newRoom = Room.init(id: UUID().uuidString, messages: [], member: [User.current!, receiver])

                        RoomService.create(room: newRoom, message: message)

                        RoomService.saveRoom(room: newRoom)

                    }
                    else{
                        self.presentAlert(title: "Not Register User", message: "The person you are trying to send message does not exist")
                        return
                    }
                }
            }
        }

        let newMessageUI = MessageUI.init(message: message)
        messageUI.append(newMessageUI)

        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

