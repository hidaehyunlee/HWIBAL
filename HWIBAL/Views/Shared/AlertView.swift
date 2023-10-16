//
//  AlertView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

import UIKit

class AlertView: UIView {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let button = UIButton(type: .system)
    
    var buttonAction: (() -> Void)?
    
    init(title: String, message: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        messageLabel.text = message
        
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 1. alertView의 스타일 설정
        self.layer.cornerRadius = 14
        self.backgroundColor = .white
        
        // 2. titleLabel 스타일 설정
        titleLabel.textColor = UIColor(red: 115/255.0, green: 78/255.0, blue: 247/255.0, alpha: 1.0)
        titleLabel.font = UIFont(name: "Inter", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 0, width: 241, height: 22)
        
        // 3. messageLabel 스타일 설정
        messageLabel.textColor = .black
        messageLabel.font = UIFont(name: "Inter", size: 13)
        messageLabel.textAlignment = .center
        messageLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: 241, height: 36)
        
        // 4. 각 뷰를 alertView에 추가
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(button)
        
        // TODO: 버튼의 위치와 크기를 설정하세요.
    }

    
    @objc private func didTapButton() {
        buttonAction?()
    }
}

