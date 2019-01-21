//
//  SendAudioMessage.swift
//  chat app
//
//  Created by Yves Songolo on 1/20/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


extension MessageViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate{

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("done playing")
    }

    func setupAudioRecorder(){

        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {

                        //load recording ui

                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            //recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            //recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }

    /// Method to initiate the record
    @objc func recording(_ sender: UILongPressGestureRecognizer){

        if sender.state == .ended {

            finishRecording(success: true)

        }
        else if sender.state == .began {

            startRecording()
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let path = recorder.url.absoluteString

        Helpers.handleAudioSendWith(url: path) { (url) in

            let sender = MessageSender.init(phoneNumber: User.current!.phoneNumber!, name: User.current!.firstName + " " + User.current!.lastName)

            let message = Message.init(id: UUID().uuidString, content: "", created: Date().toString(),receiver: self.receiverNumber, sender: sender, type: "audio", isRead: false, imageURL: nil, audioURL: url.absoluteString)
            DispatchQueue.main.async {
                self.messageUI.append(MessageUI.init(message: message))
                self.insertNewMessage(MessageUI.init(message: message))

                self.save(message)
            }
        }
    }
}

