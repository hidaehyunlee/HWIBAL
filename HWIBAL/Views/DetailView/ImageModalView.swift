//
//  ImageModalView.swift
//  HWIBAL
//
//  Created by daelee on 11/6/23.
//

import UIKit

class ImageModalView: UIView, RootView {
    static let shared = ImageModalView()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        imageView.backgroundColor = .green

        return imageView
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func initializeUI() {
        addSubview(imageView)
        addSubview(closeButton)

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(350)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(32)
        }
    }
}
