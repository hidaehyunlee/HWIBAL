//
//  HalfSizePresentationController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/26.
//

import UIKit
import AVFoundation

class BottomSheetPresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    let scrimView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        scrimView = UIView()
        scrimView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.6))
    }
    
    override func presentationTransitionWillBegin() {
        self.scrimView.alpha = 0
        self.blurEffectView.alpha = 0

        let fullBounds = containerView!.bounds
        let sheetFrame = frameOfPresentedViewInContainerView

        scrimView.frame = CGRect(x: 0, y: 0, width: fullBounds.width, height: sheetFrame.minY)

        self.containerView!.insertSubview(scrimView, at: 0)
        self.containerView!.insertSubview(blurEffectView, aboveSubview: scrimView)

        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.scrimView.alpha = 0.6
            self.blurEffectView.alpha = 0.8
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.scrimView.alpha = 0
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
            self.scrimView.removeFromSuperview()
        })
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
