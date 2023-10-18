//
//  SignInViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import GoogleSignIn
import UIKit

var loginedUser: User? // 더 효율적인 방법 고민하기

final class SignInViewController: RootViewController<SignInView> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.onGoogleSignInTapped = { [weak self] in
            self?.handleGoogleSignIn()
        }
    }

    func handleGoogleSignIn() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            let user = signInResult.user

            let email = user.profile?.email ?? "default email"
            let name = user.profile?.name ?? "default name"
            let id = String("\(String(describing: email))\(Date())".hashValue) // 나중에 바꾸는게 좋음.
            let autoLoginEnabled = true
            let autoExpireDays: Int64 = 7

            self.setUserDefaults(email)

            if let existUser = UserService.shared.getExistUser(email) {
                print("이미 가입한 회원")
                loginedUser = existUser
            } else {
                UserService.shared.createUser(email: email, name: name, id: id, autoLoginEnabled: autoLoginEnabled, autoExpireDays: autoExpireDays)
                UserService.shared.printAllUsers()
            }

            // 로그인 완료 후 MainViewController로 이동
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate
            {
                let mainViewController = MainViewController()
                sceneDelegate.window?.rootViewController = mainViewController
            }
        }
    }
    
    private func setUserDefaults(_ email: String) {
        UserDefaults.standard.set(email, forKey: "LoggedInUserEmail")
        UserDefaults.standard.set(true, forKey: "AutoLoginEnabled")
        UserDefaults.standard.set(7, forKey: "AutoExpireDays")
    }
}
