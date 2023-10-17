//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/16.
//
import EventBus
import UIKit

class CreatePageView: UIView, UITextViewDelegate {
    let bgView = UIView()
    let dateLabel = UILabel()
    let counterLabel = UILabel()
    let firstImageView = UIImageView()
    let secondImageView = UIImageView()
    let thirdImageView = UIImageView()
    
    let textView = UITextView()
    let paragraphStyle2 = NSMutableParagraphStyle()
    
    let soundButton = CircleButton(type: .record)
    let cameraButton = CircleButton(type: .photo)
    
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
        
        dateLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        dateLabel.font = FontGuide.size14
        
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineHeightMultiple = 1.18
        dateLabel.attributedText = NSMutableAttributedString(string: getCurrentDateString(), attributes: [NSAttributedString.Key.kern: -0.15, NSAttributedString.Key.paragraphStyle: paragraphStyle1])
        addSubview(dateLabel)
        
        counterLabel.alpha = 1.0
        paragraphStyle2.lineHeightMultiple = 1.03
        counterLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        counterLabel.font =  FontGuide.size16Bold
        counterLabel.textAlignment = .right
        counterLabel.attributedText = NSMutableAttributedString(string: "0 / 300", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        addSubview(counterLabel)
        
        if let image = UIImage(named: "휘발이create.svg") {
            firstImageView.image = image
            firstImageView.contentMode = .scaleAspectFit
            
            addSubview(firstImageView)
            addSubview(soundButton)
            addSubview(cameraButton)
            bringSubviewToFront(firstImageView)
            bringSubviewToFront(counterLabel)
        }
        
        textView.delegate = self
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = FontGuide.size14
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addSubview(textView)
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            counterLabel.attributedText = NSMutableAttributedString(string: "\(text.count) / 300", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
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
        let imageViewY: CGFloat = bounds.height - imageViewHeight - 31.98
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
        
        let counterLabelWidth: CGFloat = bounds.width - 293 - 45 
        let counterLabelHeight: CGFloat = 20
        let counterLabelX: CGFloat = 293
        let counterLabelY: CGFloat = bounds.height - counterLabelHeight - 197
        counterLabel.frame = CGRect(x: counterLabelX, y: counterLabelY, width: counterLabelWidth, height: counterLabelHeight)
        counterLabel.alpha = 1.0
        
        let cameraButtonX: CGFloat = 33
        let cameraButtonSize: CGFloat = cameraButton.buttonSize
        let cameraButtonY = bounds.height - cameraButtonSize - 40
        cameraButton.frame = CGRect(x: cameraButtonX, y: cameraButtonY, width: cameraButtonSize, height: cameraButtonSize)

        let soundButtonX: CGFloat = 83
        let soundButtonSize: CGFloat = soundButton.buttonSize
        let soundButtonY = bounds.height - soundButtonSize - 40
        soundButton.frame = CGRect(x: soundButtonX, y: soundButtonY, width: soundButtonSize, height: soundButtonSize)
    }
}
