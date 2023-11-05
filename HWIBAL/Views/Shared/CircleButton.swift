//
//  CircleButton.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import Foundation
import UIKit
import SnapKit

class CircleButton: UIButton {
    private let customButtonType: ButtonType
    
    init(type: ButtonType) {
        self.customButtonType = type
        super.init(frame: .zero)
        setImage(customButtonType.image, for: .normal)
        tintColor = customButtonType.titleColor
        backgroundColor = customButtonType.backgroundColor
        layer.cornerRadius = CGFloat(ButtonType.size/2)
        snp.makeConstraints { make in
            make.width.height.equalTo(ButtonType.size)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ButtonType {
        case play, pause, stop, photo, record
        
        static let size = 36
        
        var image: UIImage {
            switch self {
            case .play: return UIImage(named: "play")!
            case .pause: return UIImage(named: "pause")!
            case .stop: return UIImage(named: "stop")!
            case .photo: return UIImage(named: "photo")!
            case .record: return UIImage(named: "record")!
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .play: return .white
            case .pause: return .white
            case .stop: return .white
            case .photo: return ColorGuide.main
            case .record: return ColorGuide.main
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .play: return ColorGuide.main
            case .pause: return ColorGuide.main
            case .stop: return ColorGuide.main
            case .photo: return .white
            case .record: return .white
            }
        }
    }
}
extension CircleButton {
    var buttonSize: CGFloat {
        return CGFloat(ButtonType.size)
    }
}
