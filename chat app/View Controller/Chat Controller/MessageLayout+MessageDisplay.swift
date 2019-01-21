//
//  Displaychat+Extension.swift
//  chat app
//
//  Created by Yves Songolo on 1/18/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import FirebaseFirestore
import FirebaseStorage


/// Handle the message view layout

extension MessageViewController: MessagesLayoutDelegate {


    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {

        return 0
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {


        return CGSize(width: 0, height: 8)
    }
}


extension MessageViewController: MessagesDisplayDelegate {

    /// Method to return the backgroud color of the message bubble based on sender or receiver
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {


        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }

//    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
//                             in messagesCollectionView: MessagesCollectionView) -> Bool {
//
//
//        return false
//    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

        return .bubbleTail(corner, .curved)
    }

    
}

