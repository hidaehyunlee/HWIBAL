//
//  GoogleSignInButton.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//
import GoogleSignIn

class CustomGoogleSignInButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setTitle("내 버튼 문구", for: .normal)
        setTitleColor(.black, for: .normal) // 버튼 텍스트 색상
        backgroundColor = .white // 버튼 배경색
        layer.cornerRadius = 4 // 버튼 테두리 라운드
        layer.borderWidth = 1 // 테두리 두께
        layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signInButtonTapped() {
        GIDSignIn.sharedInstance?.signIn()
    }
}
