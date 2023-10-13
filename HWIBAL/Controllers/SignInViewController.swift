//
//  SignInViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import GoogleSignIn
import UIKit

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
            
            // signInResult로부터 가져올 수 있는 정보
            // let emailAddress = user.profile?.email
            // let fullName = user.profile?.name
            // let givenName = user.profile?.givenName
            // let familyName = user.profile?.familyName
            // let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            let user = signInResult.user

            let email = user.profile?.email ?? "default email"
            let name = user.profile?.name ?? "default name"
            let id = String("\(String(describing: email))\(Date())".hashValue) // 나중에 바꾸는게 좋음.
            let autoLoginEnabled = true
            let autoExpireDays: Int64 = 7

            UserService.shared.createUser(email: email, name: name, id: id, autoLoginEnabled: autoLoginEnabled, autoExpireDays: autoExpireDays)
            UserService.shared.printAllUsers()
        }
    }
}
