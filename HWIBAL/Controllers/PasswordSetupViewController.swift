//
//  PasswordSetupViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit

class PasswordSetupViewController: RootViewController<PasswordSetupView> {
    private var maxAttempts = 3
    private var currentAttempt = 0
    private var enteredPassword: [String] = [] {
        didSet {
            updateSubtitle()
        }
    }
    private var previousPassword: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    func initializeUI() {
        rootView.delegate = self
    }
}

extension PasswordSetupViewController: PasswordSetupViewDelegate {
    func passwordButtonTapped(_ number: String) {if enteredPassword.count < 4 {
        enteredPassword.append(number)
        updateSubtitle()

        if enteredPassword.count == 4 {
            if previousPassword.isEmpty {
                previousPassword = enteredPassword
                enteredPassword.removeAll()
                rootView.title.text = "암호 재입력"
                rootView.subTitle.text = "암호를 다시 한 번 입력해주세요."
                rootView.password.text = ""
            } else {
                currentAttempt += 1
                checkPassword()
            }
        }
    }
    }
    
    func deleteButtonTapped() {
        resetPassword()
    }
    
    func cancelButtonTapped() {
        resetPassword()
        dismiss(animated: true, completion: nil)
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
    
    private func checkPassword() {
        if enteredPassword == previousPassword {
            let passwordString = previousPassword.joined()
            UserDefaults.standard.set(true, forKey: "isLocked")
            UserDefaults.standard.set(passwordString, forKey: "appPassword")
            cancelButtonTapped()
        } else {
            if currentAttempt < maxAttempts {
                rootView.subTitle.text = "암호가 일치하지 않습니다.\n\(maxAttempts - currentAttempt)번 더 시도할 수 있습니다.\n다시 입력해주세요."
                rootView.password.text = ""
                enteredPassword.removeAll()
            } else {
                rootView.subTitle.text = "최대 시도 횟수를 초과했습니다.\n처음부터 다시 시작해주세요."
                enteredPassword.removeAll()
                previousPassword.removeAll()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func resetPassword() {
        currentAttempt = 0
        enteredPassword.removeAll()
        previousPassword.removeAll()
        rootView.password.text = ""
        rootView.subTitle.text = "사용할 암호 4자리를 입력해주세요."
    }
}
