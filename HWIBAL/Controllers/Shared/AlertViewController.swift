//
//  AlertViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

import UIKit

class AlertManager {
    
    // 싱글톤 인스턴스
    static let shared = AlertManager()
    
    private init() {}
    
    let titleFont: UIFont = FontGuide.size16Bold
    let titleColor: UIColor = ColorGuide.main
    let messageFont: UIFont = FontGuide.size14
    let messageColor: UIColor = ColorGuide.textHint
    
    func showAlert(on viewController: UIViewController, title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        
        // title에 NSAttributedString 적용
        let titleString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.foregroundColor: titleColor
        ])
        
        // message에 NSAttributedString 적용
        let messageString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font: messageFont,
            NSAttributedString.Key.foregroundColor: messageColor
        ])
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

