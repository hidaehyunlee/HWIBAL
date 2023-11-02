//
//  SceneDelegate.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
//        if SignInService.shared.isSignedIn() {
//            if let signedInUserEmail = SignInService.shared.loadSignedInUserEmail(),
//               let user = UserService.shared.getExistUser(signedInUserEmail) {
//                SignInService.shared.signedInUser = user
//                window?.rootViewController = MainViewController()
//                SignInService.shared.getSignedInUserInfo()
//            }
//        } else {
            window?.rootViewController = SignInViewController()
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
