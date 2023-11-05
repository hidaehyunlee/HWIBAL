//
//  SignInView.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import AuthenticationServices
import GoogleSignIn
import SnapKit
import UIKit

final class SignInView: UIView, RootView {
    var onGoogleSignInTapped: (() -> Void)?

    private lazy var hwibariImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "hwibari_01"))
        return imageView
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = """
        아, 휘발
        나만의 안전한 공간
        """
        label.textColor = .label
        label.font = FontGuide.size32Bold
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var imageAndTitle: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hwibariImageView, title])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 27
        return stackView
    }()

    lazy var googleSignInButton: UIButton = {
        let button = UIButton()

        button.setTitle("Google로 로그인", for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = FontGuide.size21
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorGuide.inputLine.cgColor
        
        if let image = UIImage(named: "google") {
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }

        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 48)
            make.height.equalTo(56)
        }

        return button
    }()

    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 48)
            make.height.equalTo(56)
        }
        return button
    }()

    private lazy var signInComponents: UIStackView = {
        let signInButtonsStackView = UIStackView(arrangedSubviews: [googleSignInButton, appleSignInButton])
        signInButtonsStackView.axis = .vertical
        signInButtonsStackView.spacing = 16

        let stackView = UIStackView(arrangedSubviews: [imageAndTitle, signInButtonsStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 54
        return stackView
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(signInComponents)
        signInComponents.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }

    @objc private func handleGoogleSignIn() {
        onGoogleSignInTapped?()
    }
}
