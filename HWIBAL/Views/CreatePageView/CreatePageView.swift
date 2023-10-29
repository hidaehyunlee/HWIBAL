//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/16.
//
import AVFoundation
import EventBus
import UIKit
import SnapKit

class CreatePageView: UIView, RootView, UITextViewDelegate {
    let bgView = UIView()
    let dateLabel = UILabel()
    let counterLabel = UILabel()
    let firstImageView = UIImageView()
    let soundWaveView = UIView()
    var isImageViewAttached: Bool = false

    
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
            
            addSubview(firstImageView)
            addSubview(soundButton)
            addSubview(cameraButton)
            bringSubviewToFront(firstImageView)
            bringSubviewToFront(counterLabel)
        }
        
        textView.delegate = self
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 5
        textView.font = FontGuide.size14
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addSubview(textView)
        
        soundWaveView.backgroundColor = .systemGray
        soundWaveView.isHidden = true
        addSubview(soundWaveView)
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
        
        dateLabel.frame = CGRect(x: 120, y: bgView.frame.maxY - 25 - 20, width: 153, height: 20)
        
        let imageViewWidth: CGFloat = 241
        let imageViewHeight: CGFloat = 150.02
        let imageViewX: CGFloat = 127
        let imageViewY: CGFloat = bounds.height - imageViewHeight - 40
        firstImageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewWidth, height: imageViewHeight)
        
        textView.frame = CGRect(x: dateLabel.frame.origin.x, y: dateLabel.frame.maxY + 10, width: bounds.width - 40, height: 30)
        
        let textViewPaddingHorizontal: CGFloat = 16
        let textViewPaddingVertical: CGFloat = 10
        let textViewWidth = bounds.width - 2 * textViewPaddingHorizontal
        let textViewHeight: CGFloat = 400
        textView.frame = CGRect(
            x: textViewPaddingHorizontal,
            y: dateLabel.frame.maxY + textViewPaddingVertical,
            width: textViewWidth,
            height: textViewHeight
        )
        let textViewMaxHeight: CGFloat = bounds.height - textView.frame.origin.y - (cameraButton.buttonSize + 2 * 40) 
        textView.frame = CGRect(
            x: textViewPaddingHorizontal,
            y: dateLabel.frame.maxY + textViewPaddingVertical,
            width: textViewWidth,
            height: min(textViewHeight, textViewMaxHeight)
        )
        
        counterLabel.snp.makeConstraints { make in
            let counterLabelWidth: CGFloat = bounds.width - 293 - 45
            let counterLabelHeight: CGFloat = 20
            let counterLabelX: CGFloat = 300
            let counterLabelY: CGFloat = bounds.height - counterLabelHeight - 205
            make.width.equalTo(150)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(counterLabelY)
            make.right.equalTo(textView.snp.right)//.offset(-24)
        }
        counterLabel.alpha = 1.0
        
        let cameraButtonX: CGFloat = 24
        let cameraButtonSize: CGFloat = cameraButton.buttonSize
        let cameraButtonY = bounds.height - cameraButtonSize - 40
        cameraButton.frame = CGRect(x: cameraButtonX, y: cameraButtonY, width: cameraButtonSize, height: cameraButtonSize)
        
        let soundButtonX: CGFloat = 73
        let soundButtonSize: CGFloat = soundButton.buttonSize
        let soundButtonY = bounds.height - soundButtonSize - 40
        soundButton.frame = CGRect(x: soundButtonX, y: soundButtonY, width: soundButtonSize, height: soundButtonSize)
        
        let soundWaveX: CGFloat = soundButton.frame.origin.x + soundButton.frame.width + 10
        let soundWaveY: CGFloat = soundButton.frame.origin.y
        soundWaveView.frame = CGRect(x: soundWaveX, y: soundWaveY, width: 50, height: soundButton.frame.height)
        
        
        if isImageViewAttached {
            let textViewNewHeight = textView.frame.height / 2
            textView.frame = CGRect(
                x: textView.frame.origin.x,
                y: textView.frame.origin.y,
                width: textView.frame.width,
                height: textViewNewHeight
            )
        }
    }
}
