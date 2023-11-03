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
    var user: User

    init(id: String, text: String, timestamp: Date, user: User) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.user = user
    }
}
