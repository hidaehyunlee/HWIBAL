//
//  CreatePageCameraView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/20.
//

import UIKit

class CreatePageCameraView: UIView {
    var captureButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .black
        
        captureButton = UIButton(frame: CGRect(x: (bounds.width - 70) / 2, y: bounds.height - 100, width: 70, height: 70))
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = captureButton.frame.size.width / 2
        addSubview(captureButton)
    }
}
