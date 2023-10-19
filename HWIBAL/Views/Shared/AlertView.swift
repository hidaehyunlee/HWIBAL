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
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let separatorLine = UIView()
    private let bottomSeparatorLine = UIView()

    var cancelAction: (() -> Void)?
    var confirmAction: (() -> Void)?

    init(title: String, message: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        messageLabel.text = message

        cancelButton.setTitle("취소", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.tintColor = .black

        confirmButton.setTitle("확인", for: .normal)
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        confirmButton.tintColor = .black

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 14
        backgroundColor = .systemBackground
        frame.size = CGSize(width: 273, height: 250)

        titleLabel.textColor = ColorGuide.main
        titleLabel.font = FontGuide.size16Bold
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 20, width: frame.width, height: 22)
        messageLabel.textColor = .black
        messageLabel.font = FontGuide.size14
        messageLabel.textAlignment = .center
        messageLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 20, width: frame.width, height: 36)

        cancelButton.frame = CGRect(x: 0, y: messageLabel.frame.maxY + 30, width: frame.width / 2, height: 40)
        confirmButton.frame = CGRect(x: cancelButton.frame.maxX, y: messageLabel.frame.maxY + 30, width: frame.width / 2, height: 40)

        separatorLine.backgroundColor = .systemGray
        separatorLine.frame = CGRect(x: frame.width / 2, y: messageLabel.frame.maxY + 30, width: 1, height: 40)

        bottomSeparatorLine.backgroundColor = .systemGray
        bottomSeparatorLine.frame = CGRect(x: 0, y: cancelButton.frame.minY - 1, width: frame.width, height: 1)

        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
        addSubview(separatorLine)
        addSubview(bottomSeparatorLine)
    }

    @objc private func didTapCancelButton() {
        cancelAction?()
    }

    @objc private func didTapConfirmButton() {
        confirmAction?()
    }
}
