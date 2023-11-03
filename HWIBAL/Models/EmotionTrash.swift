//
//  EmotionTrash.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/03.
//

import Foundation

struct EmotionTrash: Codable {
    var id: String
    var text: String
    var timestamp: Date
    var image: Data?
    var user: User
    var recording: Recording?

    init(id: String, text: String, timestamp: Date, user: User, image: Data?, recording: Recording?) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.user = user
        self.image = image
        self.recording = recording
    }
}
