//
//  AlertViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    func showAlert(on viewController: UIViewController, title: String, message: String, okCompletion: ((UIAlertAction) -> Void)? = nil, cancelCompletion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive, handler: okCompletion)
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelCompletion)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showMessageAlert(on viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        viewController.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertController.dismiss(animated: true) {
                completion?()
            }
        }
    }
}

