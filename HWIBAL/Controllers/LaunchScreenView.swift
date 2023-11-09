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
        lottieAnimationView.backgroundColor = UIColor(red: 52/255, green: 144/255, blue: 220/255, alpha: 1.0)
        return lottieAnimationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("런치스크린 확인")

        view.addSubview(animationView)

        animationView.frame = view.bounds
        animationView.center = view.center
        animationView.backgroundColor = UIColor.systemBackground
        animationView.alpha = 1

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
