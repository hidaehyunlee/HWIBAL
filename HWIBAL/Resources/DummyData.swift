//
//  DummyData.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import Foundation
import UIKit

var testData: [EmotionTrashDummy] = DummyData.generateDummyData()

class EmotionTrashDummy {
    let audioRecording: Data?
    let id: UUID
    let image: Data?
    let text: String
    let timestamp: Date

    init(audioRecording: Data?, id: UUID, image: Data?, text: String, timestamp: Date) {
        self.audioRecording = audioRecording
        self.id = id
        self.image = image
        self.text = text
        self.timestamp = timestamp
    }
}

class DummyData {
    static func generateDummyData() -> [EmotionTrashDummy] {
        var dummies: [EmotionTrashDummy] = []

        // 오디오와 이미지가 있는 EmotionTrash
        if let audioURL = Bundle.main.url(forResource: "exampleAudio", withExtension: "mp3"), let image = UIImage(named: "exampleImage") {
            do {
                let audioData = try Data(contentsOf: audioURL)
                if let imageData = image.pngData() {
                    let trash1 = EmotionTrashDummy(audioRecording: audioData, id: UUID(), image: imageData, text: "EmotionTrash with Audio and Image", timestamp: Date())
                    dummies.append(trash1)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        // 오디오만 있는 EmotionTrash
        if let audioURL = Bundle.main.url(forResource: "exampleAudio", withExtension: "mp3") {
            do {
                let audioData = try Data(contentsOf: audioURL)
                let trash2 = EmotionTrashDummy(audioRecording: audioData, id: UUID(), image: nil, text: "EmotionTrash with only Audio", timestamp: Date())
                dummies.append(trash2)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        // 이미지만 있는 EmotionTrash
        if let image = UIImage(named: "exampleImage") {
            if let imageData = image.pngData() {
                let trash3 = EmotionTrashDummy(audioRecording: nil, id: UUID(), image: imageData, text: "EmotionTrash with only Image", timestamp: Date())
                dummies.append(trash3)
            }
        }

        // 오디오와 이미지가 모두 없는 EmotionTrash
        let trash4 = EmotionTrashDummy(audioRecording: nil, id: UUID(), image: nil, text: "EmotionTrash with no Audio or Image", timestamp: Date())
        dummies.append(trash4)

        return dummies
    }
}
