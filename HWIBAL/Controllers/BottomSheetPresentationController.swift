//
//  HalfSizePresentationController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/26.
//

import UIKit
import AVFoundation

class BottomSheetPresentationController: UIPresentationController {
    let scrimView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        scrimView = UIView()
        scrimView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.7), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.6))
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView, let presentedView = self.presentedView else { return }
        
        scrimView.alpha = 0
        scrimView.frame = containerView.bounds
        containerView.insertSubview(scrimView, at: 0)

        presentedView.layer.cornerRadius = 10
        presentedView.layer.masksToBounds = true
        presentedView.backgroundColor = .systemBackground
        
        presentedView.frame = frameOfPresentedViewInContainerView
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.scrimView.alpha = 0.6
        }, completion: { _ in })
    }

    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.scrimView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.scrimView.removeFromSuperview()
        })
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
