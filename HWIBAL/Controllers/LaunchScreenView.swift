//
//  launch.swift
//  HWIBAL
//
//  Created by DJ S on 2023/11/09.
//

import Lottie
import UIKit

final class LaunchScreenViewController: UIViewController {
    let animationView: LottieAnimationView = {
        print("애니메이션 확인")
        let lottieAnimationView = LottieAnimationView(name: "trash")
        return lottieAnimationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("런치스크린 확인")

        view.addSubview(animationView)
        view.backgroundColor = UIColor.systemBackground

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate
            {
                if SignInService.shared.isSignedIn() {
                    print("Sign 확인")
                    if let signedInUserEmail = SignInService.shared.loadSignedInUserEmail(),
                       let user = UserService.shared.getExistUser(signedInUserEmail)
                    {
                        SignInService.shared.signedInUser = user
                        sceneDelegate.window?.rootViewController = MainViewController()

                        SignInService.shared.getSignedInUserInfo()
                    }
                } else {
                    sceneDelegate.window?.rootViewController = SignInViewController()
                }
            }
        }
    }
}
