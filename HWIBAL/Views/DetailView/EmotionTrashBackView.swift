//
//  EmotionTrashBackView.swift
//  HWIBAL
//
//  Created by daelee on 10/25/23.
//

import SnapKit
import UIKit

class EmotionTrashBackView: UIView {
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)

        addSubview(backImageView)
        addSubview(closeButton)

        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
    }
}
