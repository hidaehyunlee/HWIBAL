//
//  SceneDelegate.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = SignInService.shared.isDarkMode() ? .dark : .light
        window?.rootViewController = LaunchScreenViewController(completion: handleLaunchScreenCompletion)
    }
    
    func handleLaunchScreenCompletion() {
        if SignInService.shared.isLocked() {
            if SignInService.shared.isSignedIn() {
                authenticateForUnlock()
            } else {
                window?.rootViewController = SignInViewController()
            }
        } else {
            window?.rootViewController = SignInViewController()
        }
    }
    
    func authenticateForUnlock() {
        let context = LAContext()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let reason = "잠금을 해제하려면 Face ID 인증을 사용하세요."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.goToMainVC()
                    } else {
                        self?.showPasswordInput()
                    }
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showPasswordInput()
            }
        }
    }
    
    func showPasswordInput() {
        let passwordInputVC = PasswordInputViewController()
        passwordInputVC.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(passwordInputVC, animated: true, completion: nil)
    }
    
    func goToMainVC() {
        if let signedInUserEmail = SignInService.shared.loadSignedInUserEmail(),
           let user = UserService.shared.getExistUser(signedInUserEmail) {
            SignInService.shared.signedInUser = user
            window?.rootViewController = MainViewController()
            SignInService.shared.getSignedInUserInfo()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("자동 휘발일 확인")
        if UserDefaults.standard.bool(forKey: "isLocked") {
            print("앱이 잠겨있음")
            authenticateForUnlock()
        } else {
            print("앱이 잠겨있지 않음")
        }
        
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
