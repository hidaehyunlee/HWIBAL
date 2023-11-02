//
//  SignInViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import AuthenticationServices
import GoogleSignIn
import UIKit

final class SignInViewController: RootViewController<SignInView> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.onGoogleSignInTapped = { [weak self] in
            self?.handleGoogleSignIn()
        }
        rootView.appleSignInButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
    }

    @objc func handleAppleSignIn() {
        print("handleAppleSignIn")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func handleGoogleSignIn() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            let user = signInResult.user

            let email = user.profile?.email ?? "default email"
            let name = user.profile?.name ?? "default name"
            let id = UUID().uuidString
            let autoExpireDays: Int64 = 7

            SignInService.shared.signIn(email, name, id, autoExpireDays) // 코어데이터에 저장

            // 로그인 완료 후 MainViewController로 이동
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate
            {
                let mainViewController = MainViewController()
                sceneDelegate.window?.rootViewController = mainViewController
            }
        }
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            // 계정 정보 가져오기
            let id = appleIDCredential.user
            let name = "\(appleIDCredential.fullName.unsafelyUnwrapped.familyName!)\(appleIDCredential.fullName.unsafelyUnwrapped.givenName!)"
            let email = appleIDCredential.email!
            let idToken = appleIDCredential.identityToken!
            let autoExpireDays: Int64 = 7
            
            // let tokeStr = String(data: idToken, encoding: .utf8)
            // print("token : \(String(describing: tokeStr))")

            SignInService.shared.signIn(email, name, id, autoExpireDays)

            // 로그인 완료 후 MainViewController로 이동
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate
            {
                let mainViewController = MainViewController()
                sceneDelegate.window?.rootViewController = mainViewController
            }

        default:
            break
        }
    }

    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("로그인 실패")
    }
}
