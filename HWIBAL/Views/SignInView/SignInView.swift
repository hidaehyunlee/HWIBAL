//
//  SignInView.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import GoogleSignIn
import SnapKit
import UIKit

final class SignInView: UIView, RootView {
    var onGoogleSignInTapped: (() -> Void)?

    private let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()

        button.colorScheme = .light
        button.style = .wide

        return button
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(googleSignInButton)
        
        googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        googleSignInButton.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }

    @objc
    private func handleGoogleSignIn() {
        onGoogleSignInTapped?()
    }
}
