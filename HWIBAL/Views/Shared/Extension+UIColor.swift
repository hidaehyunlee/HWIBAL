//
//  Extension+UIColor.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/06.
//

import Foundation
import UIKit

extension UIColor {
    func isLight() -> Bool {
        var white: CGFloat = 0
        self.getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
