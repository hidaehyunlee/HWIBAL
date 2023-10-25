//
//  DummyData.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import Foundation
import UIKit

var testData = DummyData.generateDummyData()

class EmotionTrashDummy {
    let id: UUID
    let image: Data?
    let recordingFilePath: String?
    let text: String
    let timestamp: Date

    init(id: UUID, image: Data?, recordingFilePath: String?, text: String, timestamp: Date) {
        self.id = id
        self.image = image
        self.recordingFilePath = recordingFilePath
        self.text = text
        self.timestamp = timestamp
    }
}

enum DummyData {
    static func generateDummyData() -> [EmotionTrashDummy] {
        var dummies: [EmotionTrashDummy] = []

        // 오디오와 이미지가 있는 EmotionTrash
        if let image = UIImage(named: "hwibariopen"),
           let imageData = image.pngData()
        {
            let trash1 = EmotionTrashDummy(id: UUID(), image: imageData, recordingFilePath: "/Users/daelee/Desktop/hidaehyunlee-iOS/HWIBAL/HWIBAL/Resources/hwibalAudio_1.mp3", text: "오디오와 이미지가 있는 EmotionTrash", timestamp: Date())

            dummies.append(trash1)
        }

        // 오디오만 있는 EmotionTrash
        let trash2 = EmotionTrashDummy(id: UUID(), image: nil, recordingFilePath: "/Users/daelee/Desktop/hidaehyunlee-iOS/HWIBAL/HWIBAL/Resources/hwibalAudio_2.mp3", text: "오디오만 있는 EmotionTrash", timestamp: Date())

        dummies.append(trash2)

        // 이미지만 있는 EmotionTrash
        if let image = UIImage(named: "hwibariopen") {
            if let imageData = image.pngData() {
                let trash3 = EmotionTrashDummy(id: UUID(), image: imageData, recordingFilePath: nil, text: "이미지만 있는 EmotionTrash", timestamp: Date())
                dummies.append(trash3)
            }
        }

        // 오디오와 이미지가 모두 없는 EmotionTrash
        let trash4 = EmotionTrashDummy(id: UUID(), image: nil, recordingFilePath: nil,
                                       text: """
                                       오디오와 이미지가 모두 없는 EmotionTrash
                                       아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
                                       어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
                                       진짜 어이없다 이말입니다~~~~~~~
                                       아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
                                       어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
                                       진짜 어이없다 이말입니다~~~~~~~
                                       아니 진짜 오늘 개빡치는 일 있었음 니 뭔데? 니 뭔데 나한테 머라하는데;;
                                       어이없을 무;; 개빡쳐용... 하지만 귀여운 내가 참아야지^^
                                       진짜 어이없다 이말입니다~~~~~~~
                                       """,
                                       timestamp: Date())
        dummies.append(trash4)

        let dummy = dummies[0]
        print("-----------dummy----------------")
        print("ID: \(dummy.id)")
        print("imageData: \(String(describing: dummy.image))")
        print("recordingFilePath: \(String(describing: dummy.recordingFilePath))")
        print("Text: \(dummy.text)")
        print("Timestamp: \(dummy.timestamp)")
        print("---------------------------------")

        return dummies
    }
}
