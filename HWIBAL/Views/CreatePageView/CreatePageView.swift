//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

// CreatePageView.swift

import UIKit

class CreatePageView: UIView {
    let bgView = UIView()
    let dateLabel = UILabel()
    let counterLabel = UILabel()
    let imageView = UIImageView()
    
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
        counterLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        counterLabel.font = UIFont(name: "Inter-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineHeightMultiple = 1.03
        counterLabel.textAlignment = .right
        counterLabel.attributedText = NSMutableAttributedString(string: "0 / 300", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        addSubview(counterLabel)
        
        if let image = UIImage(named: "create페이지 사진.png") {
            imageView.image = image
            addSubview(imageView)
        }
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
        
        
        // Adjusting dateLabel's position and size
        dateLabel.frame = CGRect(x: 123, y: bgView.frame.maxY - 25 - 20, width: 148, height: 20)
        
        counterLabel.frame = CGRect(x: bounds.width - 45 - 55, y: bgView.frame.maxY + 467, width: 55, height: 20)
        counterLabel.alpha = 0.2
        let counterLabelY = bounds.height - 197
        counterLabel.frame.origin.y = counterLabelY - counterLabel.frame.height
        
        let imageX: CGFloat = 127
        let imageWidth: CGFloat = 241
        let imageHeight: CGFloat = 150.02
        let imageY = bounds.height - imageHeight - 31.98
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
    }
}
