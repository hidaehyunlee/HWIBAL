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
    init() {
        super.init(frame: .zero)
        setImage(UIImage(named: "close"), for: .normal)
        tintColor = ColorGuide.black
        snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
