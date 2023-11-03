//
//  User.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/03.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String
    var email: String
    var autoExpireDate: Date

    init(id: String, name: String, email: String, autoExpireDate: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.autoExpireDate = autoExpireDate
    }
}
