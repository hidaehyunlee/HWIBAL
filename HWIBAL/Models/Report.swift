//
//  Report.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/03.
//

import Foundation

struct Report: Codable {
    var id: String
    var text: String
    var timestamp: Date
    var userId: String

    init(id: String, text: String, timestamp: Date, userId: String) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.userId = userId
    }
}
