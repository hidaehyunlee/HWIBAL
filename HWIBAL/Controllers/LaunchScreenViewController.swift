//
//  LaunchScreenViewController.swift
//  HWIBAL
//
//  Created by DJ S on 2023/11/09.
//

import Lottie
import UIKit

final class LaunchScreenViewController: UIViewController {
    var completion: (() -> Void)?

    init(completion: (() -> Void)?) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let animationView: LottieAnimationView = {
        print("애니메이션 확인")
        let lottieAnimationView = LottieAnimationView(name: "trash")
        lottieAnimationView.backgroundColor = .systemBackground
        return lottieAnimationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("런치스크린 확인")

        view.backgroundColor = .systemBackground
        view.addSubview(animationView)

        let animationViewWidth: CGFloat = 200.0
        let animationViewHeight: CGFloat = 200.0
        animationView.backgroundColor = UIColor.systemBackground
        animationView.frame = CGRect(x: 0, y: 0, width: animationViewWidth, height: animationViewHeight)
        animationView.center = view.center

        animationView.play { _ in
            UIView.animate(withDuration: 0.7, animations: {
                self.animationView.alpha = 0
            }, completion: { _ in
                self.animationView.isHidden = true
                self.animationView.removeFromSuperview()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.completion?()
        }
    }
}
