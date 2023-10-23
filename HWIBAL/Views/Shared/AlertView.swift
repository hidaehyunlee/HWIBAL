//
//  AlertView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

//
//  AlertView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

import UIKit

class AlertView: UIView {
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let separatorLine = UIView()
    private let bottomSeparatorLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

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
        backgroundColor = .white
        layer.cornerRadius = 12

        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
        cancelButton.setTitle("Cancel", for: .normal)
        confirmButton.setTitle("Confirm", for: .normal)

        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)

        separatorLine.backgroundColor = .gray
        bottomSeparatorLine.backgroundColor = .gray

        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
        addSubview(separatorLine)
        addSubview(bottomSeparatorLine)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorLine.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                
                separatorLine.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
                separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
                separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
                separatorLine.heightAnchor.constraint(equalToConstant: 1),
                
                cancelButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
                cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

                confirmButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
                confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
                confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                bottomSeparatorLine.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
                bottomSeparatorLine.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
                bottomSeparatorLine.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor),
                bottomSeparatorLine.widthAnchor.constraint(equalToConstant: 1)
            ])
        }

    @objc private func didTapCancelButton() {
        cancelAction?()
    }

    @objc private func didTapConfirmButton() {
        confirmAction?()
    }
}
