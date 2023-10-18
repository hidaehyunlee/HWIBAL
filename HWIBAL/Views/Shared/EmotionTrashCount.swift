//
//  EmotionTrashCount.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/19.
//

import EventBus
import UIKit

class EmotionTrashCount {
    static var totalCount: Int = 0

    static func incrementCount() {
        totalCount += 1
    }
}
