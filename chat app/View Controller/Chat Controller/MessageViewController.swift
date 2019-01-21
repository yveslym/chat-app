//
//  ViewController.swift
//  chat app
//
//  Created by Yves Songolo on 1/13/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import MessageKit
import MessageUI
import MessageInputBar
import FirebaseFirestore
import FirebaseStorage
import Photos
import SwiftySound


class MessageViewController: MessagesViewController {

    var messageUI: [MessageUI] = []{
        didSet{
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                 self.messagesCollectionView.scrollToBottom()
            }
        }
    }
    var room: Room!
    var receiver: User!
    var receiverNumber = String()
    var isNewMessage: Bool = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: Sound!
    var player: AVPlayer!
    var playerStream: AVPlayer?
    var playerItem: AVPlayerItem?
   

    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchTextField: UITextField!


     var messageListener: ListenerRegistration?
     let db = Firestore.firestore()
     var reference: CollectionReference?

    var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                self.messageInputBar.leftStackViewItems.forEach { item in

                    //item.isEnabled = !self.isSendingPhoto

                }
            }
        }
    }


     let storage = Storage.storage().reference()


    override func viewDidLoad() {

        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MyCustomMessagesFlowLayout())
        messagesCollectionView.register(AudioCustomCell.self)

        super.viewDidLoad()


        setupDelegate()
        self.dismissKeyboard()
        setupAudioRecorder()
        setupCameraAndAudioBarButtonItem()
        setupRoomName()


    }

    func setupRoomName(){

        if !isNewMessage{

        let user = room.member.filter({$0.phoneNumber != User.current?.phoneNumber}).first
        self.title = user?.firstName
        self.receiverNumber = user?.phoneNumber ?? ""
        }
    }



    func setupDelegate(){

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
//        messageInputBar.inputTextView.delegate = self

        searchTextField.delegate = self
    }

    fileprivate func setupCameraAndAudioBarButtonItem(){
        // create and add photo button

        // 1
        let cameraItem = InputBarButtonItem(type: .system)
        let audioItem = InputBarButtonItem(type: .system)

        audioItem.tintColor = .primary
        cameraItem.tintColor = .primary
        cameraItem.image = UIImage.init(named: "noun_camera_34534")
        audioItem.image = UIImage.init(named: "microphone")
        // 2
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )

        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action:  #selector(recording(_:)))

        audioItem.addGestureRecognizer(longPressGesture)

        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        audioItem.setSize(CGSize(width: 60, height: 30), animated: false)
        audioItem.tag = 100

        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)

        // 3
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        messageInputBar.setStackViewItems([audioItem], forStack: .bottom, animated: false)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNewMessage{
            print(isNewMessage)
            self.title = "New Message"
            self.view.addSubview(searchContainer)
            searchContainer.isHidden = false
        }
        else{
            var messages = [MessageUI]()
            room.messages.forEach { (message) in

                    messages.append(MessageUI.init(message: message))
            }

            messages.sort()

           

            self.messageUI = messages

             messagesCollectionView.scrollToBottom(animated: false)
            observeMessage(id: room.id)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    private func observeMessage(id: String) {

        MessageService.observeMessage(roomId: id) { (message) in

            self.insertNewMessage(MessageUI.init(message: message))
        }
    }

    // MARK: - Helpers

    /// Method to insert new chat
     func insertNewMessage(_ message: MessageUI) {

        if messageUI.filter({ $0.messageId == message.messageId}).first != nil{
            return
        }


            messageUI.append(message)


        messageUI.sort()

        
        let isLatestMessage = messageUI.index(of: message) == (messageUI.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage


        messagesCollectionView.reloadData()

        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    /// Method to save message to firebase
    func save(_ message: Message) {

        MessageService.create(roomId: room.id, message: message)

    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(AudioCustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)

            cell.button.addTarget(self, action: #selector(playAudio(_:)), for: .touchUpInside)
            cell.button.tag = indexPath.section

            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }

    @objc func playAudio(_ sender: UIButton){
        print("play audio tapped")

        let index = sender.tag

        let message = messageUI[index]

        let url = URL.init(string:  message.message.audioURL!)

        audioPlayer = Sound.init(url: url!)


        player = AVPlayer.init(url: url!)


        player.play()

        print(player.volume)
    }


    func playVideo(url: URL) {
        let playerItem = AVPlayerItem.init(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.play()
    }

    @objc func playerItemDidPlayToEndTime() {
        // load next video or something
    }
}



// MARK: Handle adding new friend / number

extension MessageViewController: UITextFieldDelegate, UIGestureRecognizerDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        var number = textField.text
        if number?.first != "+"{
            number = "+1\(number ?? "")"
            textField.text = number
            receiverNumber = number!
        }
        DispatchQueue.global().async {
            UserService.show(type: .singleUser(phoneNumber: self.receiverNumber), completionHandler: { (user) in
                if let user = user as? User {
                    DispatchQueue.main.async {
                        self.searchTextField.text = user.firstName + " " + user.lastName
                        self.title = self.searchTextField.text
                        self.searchContainer.isHidden = true
                    }
                }
            })
        }
    }
}



