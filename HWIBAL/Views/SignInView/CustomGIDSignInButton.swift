//
//  CustomGIDSignInButton.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import GoogleSignIn

class CustomGIDSignInButton: GIDSignInButton {
    override init() {
        super.init() // Objective-C의 초기화 규칙을 적용하기 위해 super.init()을 호출합니다.
        configureButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }

    private func configureButton() {
        // 버튼 문구 변경
        self.setTitle("내 버튼 문구", for: .normal)
        // 그림자 효과 제거
        self.layer.shadowOpacity = 0
        // 테두리 라운드 적용
        self.layer.cornerRadius = 4
    }
}


