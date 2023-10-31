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
    
    private lazy var imageAndTitle: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [hwibariImageView, title])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 27
        return stackView
    }()

    private lazy var googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        return button
    }()
    
    //let googleSignInButton = MainButton(type: .googleLogin)

    func initializeUI() {
        backgroundColor = .systemBackground
        
        addSubview(imageAndTitle)
        imageAndTitle.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().offset(246)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }

        addSubview(googleSignInButton)
        googleSignInButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(imageAndTitle.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }

    @objc private func handleGoogleSignIn() {
        onGoogleSignInTapped?()
    }
}
