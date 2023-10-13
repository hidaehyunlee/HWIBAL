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
        // 각 뷰의 레이아웃과 스타일 설정하기
    }
    
    @objc private func didTapButton() {
        buttonAction?()
    }
}

