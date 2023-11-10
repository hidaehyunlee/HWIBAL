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
        
        if SignInService.shared.isDarkMode() {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
        window?.rootViewController = LaunchScreenViewController()
        
        if SignInService.shared.isSignedIn() {
            if SignInService.shared.isLocked() {
                // 앱 비번 입력 VC 띄우기
            } else {
                if let signedInUserEmail = SignInService.shared.loadSignedInUserEmail(),
                   let user = UserService.shared.getExistUser(signedInUserEmail) {
                    SignInService.shared.signedInUser = user
                    window?.rootViewController = MainViewController()
                    SignInService.shared.getSignedInUserInfo()
                }
            }
        } else {
            window?.rootViewController = SignInViewController()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("자동 휘발일 확인")
        if let email = SignInService.shared.signedInUser?.email,
           let autoExpireDate = SignInService.shared.signedInUser?.autoExpireDate {
            let currentDate = Date()
            if currentDate >= autoExpireDate {
                DispatchQueue.main.async {
                    print("삭제 로직 실행")
                    EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
                    NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
                    print("삭제 완료")
                }

                // 다음 자동 삭제를 위해 expire date 업데이트
                let autoExpireDays = UserDefaults.standard.integer(forKey: "autoExpireDays_\(email))")
                UserService.shared.updateUser(email: email, autoExpireDays: autoExpireDays)
            } else {
                let differenceInDays = Calendar.current.dateComponents([.day], from: currentDate, to: autoExpireDate).day
                print("자동 휘발일 D-\(String(describing: differenceInDays))")
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}
