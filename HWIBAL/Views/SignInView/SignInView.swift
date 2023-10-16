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

    private lazy var hwibariImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "hwibari_01"))

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()

        label.text = "아, 휘발\n나만의 안전한 공간"
        label.textColor = UIColor(red: 0.451, green: 0.306, blue: 0.969, alpha: 1) // 추후 변경
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 2

        return label
    }()
    
    private lazy var googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()

        button.colorScheme = .light
        button.style = .wide
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)

        return button
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(googleSignInButton)
        addSubview(hwibariImageView)
        addSubview(label)

        hwibariImageView.snp.makeConstraints { make in
            make.width.equalTo(93)
            make.height.equalTo(131)
            make.leading.equalToSuperview().offset(36)
            make.top.equalToSuperview().offset(246)
        }

        label.snp.makeConstraints { make in
            make.width.equalTo(248)
            make.height.equalTo(80)
            make.top.equalTo(hwibariImageView.snp.bottom).offset(27)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-109)
        }
        
        googleSignInButton.snp.makeConstraints { make in
            make.width.equalTo(333)
            make.height.equalTo(56)
            make.top.equalTo(label.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
    }

    @objc
    private func handleGoogleSignIn() {
        onGoogleSignInTapped?()
    }
}
