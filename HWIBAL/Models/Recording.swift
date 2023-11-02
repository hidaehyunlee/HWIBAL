//
//  Recording.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/03.
//

import Foundation

struct Recording: Codable {
    var dateRecorded: Date
    var duration: Double
    var filePath: String
    var title: String

    init(dateRecorded: Date, duration: Double, filePath: String, title: String) {
        self.dateRecorded = dateRecorded
        self.duration = duration
        self.filePath = filePath
        self.title = title
    }
}
