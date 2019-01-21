//
//  MainViewController.swift
//  chat app
//
//  Created by Yves Songolo on 1/14/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var friendListTableView: UITableView!

    var rooms = [Room]() {
        didSet{
            DispatchQueue.main.async {
                self.friendListTableView.reloadData()
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        friendListTableView.delegate = self
        friendListTableView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchRoom()
    }

    /// method to fetch room
    fileprivate func fetchRoom(){

        DispatchQueue.global().async {
            RoomService.show { (rooms) in

                if let rooms = rooms{

                    DispatchQueue.main.async {
                         self.rooms = rooms
                    }
                }
            }
        }
    }

    @IBAction func newMessageButtonPressed(_ sender: Any) {

        self.performSegue(withIdentifier: "newMessage", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newMessage"{
            let destination = segue.destination as! MessageViewController
            destination.isNewMessage = true
        }
        else if segue.identifier == "message"{
             let destination = segue.destination as! MessageViewController
            let room = sender as! Room
            destination.room = room
        }
    }
}



extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var room = rooms[indexPath.row]
        let friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendTableViewCell

        let receiver = room.member.filter({$0.phoneNumber != User.current!.phoneNumber}).first

        friendCell.displayName.text = (receiver!.firstName) + " " + (receiver!.lastName)

        room.messages.sort()

        let lastMesssage = room.messages.last

        if lastMesssage?.type == "photo"{
            friendCell.lastMessage.text = "Attachment: 1 image"
        }
        else if lastMesssage?.type == "audio"{
            friendCell.lastMessage.text = "Attachment: 1 audio"
        }
        else{
            friendCell.lastMessage.text = lastMesssage?.content
        }


        if let picUrl = receiver?.profilePictureURL{

            let url = URL.init(string: picUrl)
            
             friendCell.profilePicture.kf.indicatorType = .activity

            friendCell.profilePicture.kf.setImage(with:url)
        }

        return friendCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        self.performSegue(withIdentifier: "message", sender: room)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}



