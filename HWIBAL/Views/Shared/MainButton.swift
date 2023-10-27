//
//  MainButton.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import Foundation
import UIKit
import SnapKit

class MainButton: UIButton {
    private let customButtonType: ButtonType
    
    init(type: ButtonType) {
        self.customButtonType = type
        super.init(frame: .zero)
        setAttributedTitle(customButtonType.title, for: .normal)
        setImage(customButtonType.image, for: .normal)
        titleLabel?.font = customButtonType.font
        setTitleColor(customButtonType.titleColor, for: .normal)
        backgroundColor = customButtonType.backgroundColor
        layer.cornerRadius = 4
        layer.borderColor = customButtonType.borderColor.cgColor
        layer.borderWidth = customButtonType.borderWidth
        snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(56)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ButtonType {
        case googleLogin(_ image: UIImage?), appleLogin(_ image: UIImage?), delete, withdrawal
        
        var title: NSAttributedString {
            switch self {
            case .googleLogin:
                return NSAttributedString(string:" Google로 로그인")
            case .appleLogin:
                return NSAttributedString(string: " Apple로 로그인")
            case .delete:
                return NSAttributedString(string: "아, 휘발🔥")
            case .withdrawal:
                let underlinedTitle = NSAttributedString(string: "회원탈퇴", attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ])
                return underlinedTitle
            }
        }
        
        var image: UIImage? {
            switch self {
            case .googleLogin(let image), .appleLogin(let image):
                return image
            default:
                return nil
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .googleLogin: return ColorGuide.inputLine
            case .appleLogin: return .clear
            case .delete: return .clear
            case .withdrawal: return ColorGuide.inputLine
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .googleLogin: return 1
            case .appleLogin: return 0
            case .delete: return 0
            case .withdrawal: return 1
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .googleLogin: return .white
            case .appleLogin: return .black
            case .delete: return ColorGuide.main
            case .withdrawal: return .white
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .googleLogin: return .black
            case .appleLogin: return .white
            case .delete: return .white
            case .withdrawal: return .black
            }
        }
        
        var font: UIFont {
            switch self {
            case .googleLogin: return FontGuide.size19Bold
            case .appleLogin: return FontGuide.size19Bold
            case .delete: return FontGuide.size19Bold
            case .withdrawal: return FontGuide.size16
            }
        }
    }
}
