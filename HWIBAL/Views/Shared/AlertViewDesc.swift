//
//  AlertViewDesc.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/17.
//

import UIKit

class AlertViewDesc: UIView {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    init(title: String, message: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        messageLabel.text = message

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 14
        backgroundColor = .white
        frame.size = CGSize(width: 273, height: 200)

        titleLabel.textColor = ColorGuide.main
        titleLabel.font = FontGuide.size16Bold
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 20, width: frame.width, height: 22)

        messageLabel.textColor = .black
        messageLabel.font = FontGuide.size14
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 9, width: frame.width, height: 36)

        addSubview(titleLabel)
        addSubview(messageLabel)
    }

    func dismissAfter(seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.removeFromSuperview()
        }
    }
}
