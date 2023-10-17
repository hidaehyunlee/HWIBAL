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
        
        if isLoggedIn() {
            if let loggedInUserEmail = loadLoggedInUserEmail(),
               let user = UserService.shared.getExistUser(loggedInUserEmail) {
                UserService.loginedUser = user
                window?.rootViewController = MainViewController()
                getUserInfo()
            }
        } else {
            window?.rootViewController = SignInViewController()
        }
    }
    
    private func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    private func loadLoggedInUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: "LoggedInUserEmail")
    }
    
    private func getUserInfo() {
        print("--------------------------------")
        print("👤 [로그인 유저 정보]")
        print("Email: \(UserService.loginedUser?.email ?? "No email")\nName: \(UserService.loginedUser?.name ?? "No name")\nID: \(UserService.loginedUser?.id ?? "No ID")\nAutoLoginEnabled: \(String(describing: UserService.loginedUser?.autoLoginEnabled))\nAutoExpireDays: \(String(describing: UserService.loginedUser?.autoExpireDays))")
        print("--------------------------------")
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
