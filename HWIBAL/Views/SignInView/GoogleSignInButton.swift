////
////  GoogleSignInButton.swift
////  HWIBAL
////
////  Created by daelee on 10/16/23.
////
//
//import UIKit
//import SnapKit
//import GoogleSignIn
//
//class GoogleSignInButton: UIButton {
//    var onGoogleSignInTapped: (() -> Void)?
//
//    private func initializeUI() {
//        setTitle("Sign in with Google", for: FontGuide.size24Bold)
//        setTitleColor(.black, for: .normal)
//        backgroundColor = .white
//        layer.cornerRadius = 4
//        layer.borderWidth = 1
//        layer.borderColor = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 1).cgColor
//        addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
//    }
//
//    @objc
//    private func handleGoogleSignIn() {
//        onGoogleSignInTapped?()
//    }
//}
