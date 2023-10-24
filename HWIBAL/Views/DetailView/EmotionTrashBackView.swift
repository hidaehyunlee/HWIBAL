//
//  EmotionTrashBackView.swift
//  HWIBAL
//
//  Created by daelee on 10/25/23.
//

import SnapKit
import UIKit

class EmotionTrashBackView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "hwibari_default")

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

        addSubview(imageView)
        addSubview(closeButton)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
    }
}
