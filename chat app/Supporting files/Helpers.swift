//
//  Helpers.swift
//  chat app
//
//  Created by Yves Songolo on 1/18/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import AVFoundation
import Firebase

struct Helpers{

    static func recordAudio(){



     
    }

    static func handleAudioSendWith(url: String, completion: @escaping (URL)->()) {
        guard let fileUrl = URL(string: url) else {
            return
        }
        let fileName = NSUUID().uuidString + ".m4a"

        let ref = Storage.storage().reference().child("message_voice").child(fileName)

            ref.putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error ?? "error")
            }

                ref.downloadURL(completion: { (url, err) in
                    if error == nil{
                        completion(url!)
                    }
                })

//            if let downloadUrl = metadata?.downloadURL()?.absoluteString {
//                print(downloadUrl)
//                let values: [String : Any] = ["audioUrl": downloadUrl]
//                self.sendMessageWith(properties: values)
//            }
        }
    }


}
