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


        
        let newMessageUI = MessageUI.init(message: message)
        messageUI.append(newMessageUI)

        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

