//
//  CloseButton.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import Foundation
import UIKit
import SnapKit

class CloseButton: UIButton {
    enum ButtonColor {
        case white
        case black
    }
    
    init(color: ButtonColor) {
        super.init(frame: .zero)
        let closeImage = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        setImage(closeImage, for: .normal)
        switch color {
        case .white:
            tintColor = .white
        case .black:
            tintColor = .black
        }
        snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
