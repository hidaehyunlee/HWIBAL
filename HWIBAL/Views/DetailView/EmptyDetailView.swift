//
//  EmptyDetailView.swift
//  HWIBAL
//
//  Created by daelee on 10/31/23.
//

import SnapKit
import UIKit

final class EmptyDetailView: UIView {
    let emptyHwibari: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(named: "hwibariopen01")

        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "텅 비었어요."
        label.font = FontGuide.size24Bold
        label.textColor = .label
        label.textAlignment = .center

        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()

        label.text = """
        쌓인 감정쓰레기가 없어요.
        아주 잘하고 있어요!
        """
        label.font = FontGuide.size16
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }()

    lazy var title: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])

        stackView.axis = .vertical
        stackView.spacing = 20

        return stackView
    }()

    lazy var imageAndTitle: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyHwibari, title])

        stackView.axis = .vertical
        stackView.spacing = 50

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(imageAndTitle)

        imageAndTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
