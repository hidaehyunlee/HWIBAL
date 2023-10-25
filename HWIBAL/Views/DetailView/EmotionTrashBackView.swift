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

        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton()

        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)

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
        backgroundColor = .green

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