//
//  PasswordInputView.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit
import SnapKit

protocol PasswordInputViewDelegate: AnyObject {
    func passwordButtonTapped(_ title: String)
    func deleteButtonTapped()
    func cancelButtonTapped()
}

final class PasswordInputView: UIView, RootView {
    weak var delegate: PasswordSetupViewDelegate?
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "암호 입력"
        label.font = FontGuide.size21Bold
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "암호 4자리를 입력해주세요."
        label.font = FontGuide.size14
        label.textColor = ColorGuide.textHint
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let password: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontGuide.size14
        label.textColor = ColorGuide.textHint
        label.textAlignment = .center
        return label
    }()
    
    lazy var numberButtons: [UIButton] = {
        var buttons: [UIButton] = []
        for i in 1...9 {
            let button = makeNumberButton(title: "\(i)", image: nil)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }()

    lazy var cancelButton: UIButton = makeNumberButton(title: "취소", image: nil)
    lazy var zeroButton: UIButton = makeNumberButton(title: "0", image: nil)
    lazy var deleteButton: UIButton = makeNumberButton(title: nil, image: UIImage(systemName: "delete.left"))
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            makeHorizontalStackView(buttons: numberButtons[0...2]),
            makeHorizontalStackView(buttons: numberButtons[3...5]),
            makeHorizontalStackView(buttons: numberButtons[6...8]),
            makeHorizontalStackView(buttons: [cancelButton, zeroButton, deleteButton])
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    private func makeNumberButton(title: String?, image: UIImage?) -> UIButton {
        let button = UIButton()

        if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.font = FontGuide.size21Bold
            if title == "취소" {
                button.titleLabel?.font = FontGuide.size16Bold
            }
        }

        if let image = image {
            button.setImage(image, for: .normal)
            button.tintColor = .label
        }

        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.snp.makeConstraints { make in
            make.size.equalTo(50)
        }

        return button
    }

    private func makeHorizontalStackView(buttons: ArraySlice<UIButton>) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: Array(buttons))
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeUI()
        zeroButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .systemBackground
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
        
        addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(15)
        }
        
        addSubview(password)
        password.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitle.snp.bottom).offset(30)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let number = sender.currentTitle else { return }
        delegate?.passwordButtonTapped(number)
    }

    @objc private func deleteButtonTapped() {
        delegate?.deleteButtonTapped()
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }
}
