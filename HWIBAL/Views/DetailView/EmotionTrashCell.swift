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
    var filePath: String?

    lazy var playPauseButton: UIButton = {
        let button = UIButton()

        button.isHidden = true
        if let image = UIImage(named: "play") {
            let colorImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(colorImage, for: .normal)
            button.tintColor = UIColor.white
        }

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

        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontGuide.size16Bold,
            .foregroundColor: UIColor.white
        ]

        textView.attributedText = NSAttributedString(string: "", attributes: attributes)
        textView.backgroundColor = ColorGuide.main
        textView.isEditable = false
        textView.isSelectable = false

        return textView
    }()

    lazy var imageContentView: UIImageView = {
        let imageView = UIImageView()

        imageView.backgroundColor = ColorGuide.main
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isHidden = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImageModal))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        return imageView
    }()

    func initializeUI() {
        backgroundColor = ColorGuide.main

        addSubview(daysAgoLabel)
        addSubview(textContentLabel)
        addSubview(imageContentView)
        addSubview(playPauseButton)

        textContentLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(315 * UIScreen.main.bounds.height / 852) // figma 기준 -20

            if imageContentView.isHidden == true {
                make.height.equalTo((315 + 160 + 20) * UIScreen.main.bounds.height / 852)
            }
        }

        imageContentView.snp.makeConstraints { make in
            if self.isHidden == false {
                make.top.equalTo(textContentLabel.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(160 * UIScreen.main.bounds.height / 852) // figma보다 기준 -20
            }
        }

        daysAgoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
        }

        playPauseButton.snp.makeConstraints { make in
            make.top.equalTo(imageContentView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(36)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageContentView.isHidden = true
        daysAgoLabel.text = ""
        textContentLabel.text = ""
    }

    func transformToLarge() {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }

    func transformToStandard() {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform.identity
        }
    }

    @objc func playPauseButtonTapped() {
        // filePath가 nil이 아닌지 확인한 후 재생을 시도합니다.
        guard let filePath = filePath else {
            return
        }
        print("파일 경로 존재 \(filePath)")
        // filePath를 사용하여 오디오 재생
        AudioPlayerService(filePath: filePath).playAudio()
    }

    @objc private func showImageModal() {
        guard let image = imageContentView.image else {
            return
        }

        let modalViewController = UIViewController()
        modalViewController.modalPresentationStyle = .overFullScreen

        let imageView = UIImageView(image: image)
        modalViewController.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
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
