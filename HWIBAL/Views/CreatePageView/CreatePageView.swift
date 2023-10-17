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
    let soundImageView = UIImageView()
    let cameraImageView = UIImageView()
    let textView = UITextView()

    let paragraphStyle2 = NSMutableParagraphStyle()
    
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
        
        if let font = UIFont(name: "Inter-Medium", size: 14) {
            dateLabel.font = font
        } else {
            dateLabel.font = UIFont.systemFont(ofSize: 14)
        }
        
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineHeightMultiple = 1.18
        dateLabel.attributedText = NSMutableAttributedString(string: getCurrentDateString(), attributes: [NSAttributedString.Key.kern: -0.15, NSAttributedString.Key.paragraphStyle: paragraphStyle1])
        addSubview(dateLabel)
        
        // Counter Label
        counterLabel.alpha = 0.2
        counterLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        counterLabel.font = UIFont(name: "Inter-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        
        paragraphStyle2.lineHeightMultiple = 1.03
        counterLabel.alpha = 0.2
        counterLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        counterLabel.font = UIFont(name: "Inter-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        counterLabel.textAlignment = .right
        counterLabel.attributedText = NSMutableAttributedString(string: "0 / 300", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        addSubview(counterLabel)
        
        if let image = UIImage(named: "create페이지 사진.png") {
            firstImageView.image = image
            addSubview(firstImageView)
        }
        
        if let secondImage = UIImage(named: "동그라미.png") {
            secondImageView.image = secondImage
            addSubview(secondImageView)
            
            thirdImageView.image = secondImage
            addSubview(thirdImageView)
        }
        
        if let soundImage = UIImage(named: "음성.png") {
            soundImageView.image = soundImage
            addSubview(soundImageView)
        }
        
        if let cameraImage = UIImage(named: "카메라.png") {
            cameraImageView.image = cameraImage
            addSubview(cameraImageView)
        }
        textView.delegate = self
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 14)
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
        
        dateLabel.frame = CGRect(x: 123, y: bgView.frame.maxY - 25 - 20, width: 148, height: 20)
        
        counterLabel.frame = CGRect(x: bounds.width - 45 - 55, y: bgView.frame.maxY + 467, width: 70, height: 20)
        counterLabel.alpha = 0.2
        let counterLabelY = bounds.height - 197
        counterLabel.frame.origin.y = counterLabelY - counterLabel.frame.height
        
        let imageX: CGFloat = 127
        let imageWidth: CGFloat = 241
        let imageHeight: CGFloat = 150.02
        let imageY = bounds.height - imageHeight - 31.98
        firstImageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        let secondImageX: CGFloat = 74
        let secondImageWidth: CGFloat = 36
        let secondImageHeight: CGFloat = 36
        let secondImageY = bounds.height - secondImageHeight - 32
        secondImageView.frame = CGRect(x: secondImageX, y: secondImageY, width: secondImageWidth, height: secondImageHeight)
        
        let thirdImageX: CGFloat = 25
        let thirdImageWidth: CGFloat = 36
        let thirdImageHeight: CGFloat = 36
        let thirdImageY = bounds.height - secondImageHeight - 32
        thirdImageView.frame = CGRect(x: thirdImageX, y: thirdImageY, width: secondImageWidth, height: secondImageHeight)
        
        let soundImageX: CGFloat = 83
        let soundImageWidth: CGFloat = 19
        let soundImageHeight: CGFloat = 19
        let soundImageY = bounds.height - soundImageHeight - 40
        soundImageView.frame = CGRect(x: soundImageX, y: soundImageY, width: soundImageWidth, height: soundImageHeight)
        
        let cameraImageX: CGFloat = 33
        let cameraImageWidth: CGFloat = 20
        let cameraImageHeight: CGFloat = 20
        let cameraImageY = bounds.height - cameraImageHeight - 40
        cameraImageView.frame = CGRect(x: cameraImageX, y: cameraImageY, width: cameraImageWidth, height: cameraImageHeight)
        
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
    }
}

