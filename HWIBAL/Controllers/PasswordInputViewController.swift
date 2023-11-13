//
//  PasswordInputViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit
import LocalAuthentication

class PasswordInputViewController: RootViewController<PasswordInputView> {
    private var enteredPassword: [String] = [] {
        didSet {
            updateSubtitle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
        authenticateWithBiometrics()
    }
}

extension PasswordInputViewController: PasswordSetupViewDelegate {
    func passwordButtonTapped(_ number: String) {
        if enteredPassword.count < 4 {
            enteredPassword.append(number)
            updateSubtitle()

            if enteredPassword.count == 4 {
                checkPassword()
            } else {
            }
        }
    }
    
    func deleteButtonTapped() {
        resetPassword()
    }
    
    func cancelButtonTapped() {
        resetPassword()
        UserDefaults.standard.set(false, forKey: "isSignedIn")
        
        let signInVC = SignInViewController()
            
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = scene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = signInVC
        }
    }
    
    private func updateSubtitle() {
        var maskedPassword = ""
        for (index, _) in enteredPassword.enumerated() {
            let isLastDigit = index == enteredPassword.count - 1
            let textColor: UIColor = isLastDigit ? ColorGuide.main : ColorGuide.textHint
            maskedPassword += "●"
            let attributedString = NSAttributedString(string: maskedPassword, attributes: [.foregroundColor: textColor])
            rootView.password.attributedText = attributedString
        }
    }
    
    private func authenticateWithBiometrics() {
        if isBiometricAuthenticationAvailable() {
            let context = LAContext()
            context.localizedFallbackTitle = "비밀번호 입력"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "잠금을 해제하려면 Face ID 인증을 사용하세요.") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.enterPasswordSuccess()
                    }
                } else {
                    self.checkPassword()
                }
            }
        } else {
            checkPassword()
        }
    }
    
    func isBiometricAuthenticationAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            // Biometric 인증이 지원되지 않거나 설정되어 있지 않은 경우
            return false
        }
    }
    
    private func checkPassword() {
        let enterPassword = enteredPassword.joined()
        let password = UserDefaults.standard.string(forKey: "appPassword")
        
        if enterPassword == password {
            self.enteredPassword.removeAll()
            self.enterPasswordSuccess()
        } else {
            self.rootView.subTitle.text = "암호가 일치하지 않습니다.\n다시 입력해주세요."
            self.rootView.password.text = ""
            self.enteredPassword.removeAll()
        }
    }
    
    func resetPassword() {
        enteredPassword.removeAll()
        rootView.password.text = ""
        rootView.subTitle.text = "암호 4자리를 입력해주세요."
    }
    
    private func enterPasswordSuccess() {
        if let signedInUserEmail = SignInService.shared.loadSignedInUserEmail(),
           let user = UserService.shared.getExistUser(signedInUserEmail) {
            SignInService.shared.signedInUser = user
            SignInService.shared.getSignedInUserInfo()
        }
        
        let mainVC = MainViewController()
            
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = scene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = mainVC
        }
    }
}

