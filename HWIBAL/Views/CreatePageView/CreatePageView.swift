//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/16.
//
import AVFoundation
import EventBus
import SnapKit
import UIKit

class CreatePageView: UIView, RootView, UITextViewDelegate {
    let bgView = UIView()
    let dateLabel = UILabel()
    let counterLabel = UILabel()
    let firstImageView = UIImageView()
    let soundWaveView = UIView()
    var isImageViewAttached: Bool = false
    let playButton = CircleButton(type: .play)

    let textView = UITextView()
    let paragraphStyle2 = NSMutableParagraphStyle()
    
    let soundButton: CircleButton = {
        let button = CircleButton(type: .record)
        return button
    }()
    
    let cameraButton = CircleButton(type: .photo)
    
    func initializeUI() {
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        bgView.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
        addSubview(bgView)
        
        dateLabel.textColor = ColorGuide.textHint
        dateLabel.font = FontGuide.size14
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineHeightMultiple = 1.18
        dateLabel.attributedText = NSMutableAttributedString(string: getCurrentDateString(), attributes: [NSAttributedString.Key.kern: -0.15, NSAttributedString.Key.paragraphStyle: paragraphStyle1])
        addSubview(dateLabel)
        
        counterLabel.alpha = 1.0
        paragraphStyle2.lineHeightMultiple = 1.03
        counterLabel.textColor = ColorGuide.textHint
        counterLabel.font = FontGuide.size14Bold
        counterLabel.attributedText = NSMutableAttributedString(string: "0 / 300", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        counterLabel.textAlignment = .right
        addSubview(counterLabel)
        
        if let image = UIImage(named: "hwibari_create") {
            firstImageView.image = image
            firstImageView.contentMode = .scaleAspectFill
        }
        
            addSubview(firstImageView)
            addSubview(soundButton)
            addSubview(cameraButton)
            bringSubviewToFront(firstImageView)
            bringSubviewToFront(counterLabel)
        
        
        textView.delegate = self
        textView.backgroundColor = .systemBackground
        textView.font = FontGuide.size14
        addSubview(textView)
        
//        soundWaveView.backgroundColor = .systemGray
//        soundWaveView.isHidden = true
//        addSubview(soundWaveView)
        
        addSubview(playButton)
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            counterLabel.attributedText = NSMutableAttributedString(string: "\(text.count) / 300", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
            counterLabel.textAlignment = .right
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 300
    }
    
    func getCurrentDateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return formatter.string(from: date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 168)
        bgView.backgroundColor = UIColor(red: 60/60, green: 60/60, blue: 67/67, alpha: 0.36)
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(bgView.snp.bottom).offset(-25 - 20)
            make.centerX.equalToSuperview()
        }

        firstImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(firstImageView.snp.width).multipliedBy(150.02/241)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }

        counterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(firstImageView.snp.top).offset(-15)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(counterLabel.snp.top).offset(-50).priority(.high)
        }

        cameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-40)
        }

        soundButton.snp.makeConstraints { make in
            make.size.equalTo(soundButton.buttonSize)
            make.leading.equalTo(cameraButton.snp.trailing).offset(16)
            make.bottom.equalTo(cameraButton.snp.bottom)
        }

        playButton.snp.makeConstraints { make in
            make.size.equalTo(playButton.buttonSize)
            make.leading.equalTo(soundButton.snp.leading)
            make.bottom.equalTo(soundButton.snp.top).offset(-10)
        }

//        soundWaveView.snp.makeConstraints { make in
//            make.leading.equalTo(soundButton.snp.trailing).offset(10)
//            make.centerY.equalTo(soundButton.snp.centerY)
//            make.width.equalTo(50)
//            make.height.equalTo(soundButton.snp.height)
//        }
    }
}
