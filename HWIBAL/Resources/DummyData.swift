//
//  DummyData.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import Foundation
import UIKit

var testData = (0 ... 21).map { _ in
    EmotionTrashDummy(audioRecording: nil, id: UUID(), image: nil, text: """
    아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
    어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
    진짜 어이없다 이말입니다~~~~~~~
    아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
    어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
    진짜 어이없다 이말입니다~~~~~~~
    아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
    어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
    진짜 어이없다 이말입니다~~~~~~~
    """, timestamp: Date(), isDimmed: true)
}

class EmotionTrashDummy {
    let audioRecording: Data?
    let id: UUID
    let image: Data?
    let text: String
    let timestamp: Date
    var isDimmed: Bool
    
    init(audioRecording: Data?, id: UUID, image: Data?, text: String, timestamp: Date, isDimmed: Bool) {
        self.audioRecording = audioRecording
        self.id = id
        self.image = image
        self.text = text
        self.timestamp = timestamp
        self.isDimmed = isDimmed
    }
}

//
//class DummyData {
//    static func generateDummyData() -> [EmotionTrashDummy] {
//        var dummies: [EmotionTrashDummy] = []
//
//        // 오디오와 이미지가 있는 EmotionTrash
//        if let audioURL = Bundle.main.url(forResource: "exampleAudio", withExtension: "mp3"), let image = UIImage(named: "exampleImage") {
//            do {
//                let audioData = try Data(contentsOf: audioURL)
//                if let imageData = image.pngData() {
//                    let trash1 = EmotionTrashDummy(audioRecording: audioData, id: UUID(), image: imageData, text: """
//                        아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
//                        어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
//                        진짜 어이없다 이말입니다~~~~~~~
//                        아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
//                        어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
//                        진짜 어이없다 이말입니다~~~~~~~
//                        아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
//                        어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
//                        진짜 어이없다 이말입니다~~~~~~~
//                        """, timestamp: Date())
//                    dummies.append(trash1)
//                }
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//
//        // 오디오만 있는 EmotionTrash
//        if let audioURL = Bundle.main.url(forResource: "exampleAudio", withExtension: "mp3") {
//            do {
//                let audioData = try Data(contentsOf: audioURL)
//                let trash2 = EmotionTrashDummy(audioRecording: audioData, id: UUID(), image: nil, text: "EmotionTrash with only Audio", timestamp: Date())
//                dummies.append(trash2)
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//
//        // 이미지만 있는 EmotionTrash
//        if let image = UIImage(named: "exampleImage") {
//            if let imageData = image.pngData() {
//                let trash3 = EmotionTrashDummy(audioRecording: nil, id: UUID(), image: imageData, text: "EmotionTrash with only Image", timestamp: Date())
//                dummies.append(trash3)
//            }
//        }
//
//        // 오디오와 이미지가 모두 없는 EmotionTrash
//        let trash4 = EmotionTrashDummy(audioRecording: nil, id: UUID(), image: nil, text: "EmotionTrash with no Audio or Image", timestamp: Date())
//        dummies.append(trash4)
//
//        return dummies
//    }
//}
