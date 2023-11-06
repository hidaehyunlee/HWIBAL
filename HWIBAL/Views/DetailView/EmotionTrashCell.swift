//
//  EmotionTrashCell.swift
//  HWIBAL
//
//  Created by daelee on 10/18/23.
//

import SnapKit
import UIKit

class EmotionTrashCell: UICollectionViewCell {
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

    var imageModalView: ImageModalView = .init()

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

    override func prepareForReuse() {
        super.prepareForReuse()
        showImageButton.isHidden = false
        imageModalView.removeFromSuperview()
        daysAgoLabel.text = ""
        textContentLabel.text = ""
        // imageModalView.backImageView.image = nil
    }

    @objc private func showImageButtonTapped() {
        guard let image = imageModalView.imageView.image else {
            return
        }

        let modalViewController = UIViewController()
        modalViewController.modalPresentationStyle = .overFullScreen

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        modalViewController.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(modalViewController.view)
            make.centerY.equalTo(modalViewController.view)
            make.width.equalTo(modalViewController.view).multipliedBy(0.8)
            make.height.equalTo(modalViewController.view).multipliedBy(0.8)
        }

        modalViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)

        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        modalViewController.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(modalViewController.view).offset(40)
            make.trailing.equalTo(modalViewController.view).offset(-20)
            make.width.height.equalTo(32)
        }

        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(modalViewController, animated: true, completion: nil)
        }
    }

    @objc private func closeModal() {
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.dismiss(animated: true, completion: nil)
        }
    }
}
