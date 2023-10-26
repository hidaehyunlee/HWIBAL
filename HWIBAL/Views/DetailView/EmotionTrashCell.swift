//
//  EmotionTrashCell.swift
//  HWIBAL
//
//  Created by daelee on 10/18/23.
//

import SnapKit
import UIKit

class EmotionTrashCell: UICollectionViewCell, RootView {
    static let identifier = "EmotionTrashCell"

    lazy var showImageButton: UIButton = {
        let button = UIButton()

        button.setTitle("사진보기", for: .normal)
        button.titleLabel?.font = FontGuide.size14Bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorGuide.subButton.withAlphaComponent(0.5)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showImageButtonTapped), for: .touchUpInside) // ✏️VC로 옮기기

        return button
    }()

    lazy var daysAgoLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.font = FontGuide.size14
        label.textColor = .white

        return label
    }()

    lazy var textContentLabel: UITextView = {
        let textView = UITextView()

        textView.text = ""
        textView.backgroundColor = ColorGuide.main
        textView.font = FontGuide.size14
        textView.textColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        
        return textView
    }()

    var emotionTrashBackView: EmotionTrashBackView = .init()

    public func configure() {
        // initializeUI()
        // print(testData[0])

        // MARK: - Title, SubTitle
    }

    func initializeUI() {
        backgroundColor = ColorGuide.main

        addSubview(showImageButton)
        addSubview(daysAgoLabel)
        addSubview(textContentLabel)

        showImageButton.snp.makeConstraints { make in
            make.width.equalTo(77)
            make.height.equalTo(28)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }

        daysAgoLabel.snp.makeConstraints { make in
            make.top.equalTo(showImageButton.snp.topMargin)
            make.leading.equalToSuperview().offset(20)
        }

        textContentLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(showImageButton.snp.topMargin).offset(-20)
        }
    }

    // ✏️VC로 옮기기
    @objc private func showImageButtonTapped() {
        // emotionTrashBackView를 추가할 때 전환효과를 줘야함
        UIView.transition(with: self, duration: 0.6, options: .transitionFlipFromLeft, animations: {
            self.addSubview(self.emotionTrashBackView)
            self.emotionTrashBackView.closeButton.addTarget(self, action: #selector(self.closeButtonTapped), for: .touchUpInside) // ✏️VC로 옮기기

            self.emotionTrashBackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        })
    }

    // ✏️VC로 옮기기
    @objc private func closeButtonTapped() {
        UIView.transition(with: self, duration: 0.6, options: .transitionFlipFromRight, animations: {
            self.emotionTrashBackView.removeFromSuperview()
        })
    }
}
