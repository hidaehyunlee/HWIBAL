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

class DummyData {
    static func generateDummyData() -> [EmotionTrashDummy] {
        var dummies: [EmotionTrashDummy] = []
        
        // 오디오와 이미지가 있는 EmotionTrash
        if let image = UIImage(named: "exampleImage"),
           let imageData = image.pngData(),
           let audioURL = Bundle.main.url(forResource: "exampleAudio", withExtension: "mp3") {
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let destinationURL = documentsURL.appendingPathComponent("exampleAudio.mp3")
                try FileManager.default.copyItem(at: audioURL, to: destinationURL)
                
                let trash1 = EmotionTrashDummy(id: UUID(), image: imageData, recordingFilePath: destinationURL.path, text: "EmotionTrash with Audio and Image", timestamp: Date())
                dummies.append(trash1)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
            
        // 오디오만 있는 EmotionTrash
        if let audioURL = Bundle.main.url(forResource: "exampleAudio", withExtension: "mp3") {
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let destinationURL = documentsURL.appendingPathComponent("exampleAudio.mp3")
                try FileManager.default.copyItem(at: audioURL, to: destinationURL)
                
                let trash2 = EmotionTrashDummy(id: UUID(), image: nil, recordingFilePath: destinationURL.path, text: "EmotionTrash with only Audio", timestamp: Date())
                dummies.append(trash2)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // 이미지만 있는 EmotionTrash
        if let image = UIImage(named: "exampleImage") {
            if let imageData = image.pngData() {
                let trash3 = EmotionTrashDummy(id: UUID(), image: imageData, recordingFilePath: nil, text: "EmotionTrash with only Image", timestamp: Date())
                dummies.append(trash3)
            }
        }
        
        // 오디오와 이미지가 모두 없는 EmotionTrash
        let trash4 = EmotionTrashDummy(id: UUID(), image: nil, recordingFilePath: nil, text: "EmotionTrash with no Audio or Image", timestamp: Date())
        dummies.append(trash4)
        
        return dummies
    }
}
