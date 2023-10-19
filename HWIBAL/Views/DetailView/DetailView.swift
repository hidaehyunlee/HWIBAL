//
//  DetailView.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import SnapKit
import UIKit

final class DetailView: UIView, RootView {
    private lazy var goToFirstButton: UIButton = {
        let button = UIButton()

        button.setTitle("맨 처음으로 ", for: .normal)
        button.titleLabel?.font = FontGuide.size14Bold
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "<-"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true

        return button
    }()

    private lazy var numberOfPage: UILabel = {
        let label = UILabel()
        let currentPageText = "(1 "
        let totalPageText = "/ 5)"
        let attributedString = NSMutableAttributedString(string: currentPageText, attributes: [
            .font: FontGuide.size16Bold,
            .foregroundColor: UIColor.black
        ])
        let totalPageAttributedString = NSAttributedString(string: totalPageText, attributes: [
            .font: FontGuide.size16Bold,
            .foregroundColor: ColorGuide.textHint
        ])

        attributedString.append(totalPageAttributedString)
        label.attributedText = attributedString
        label.textAlignment = .right

        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 307, height: 373)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EmotionTrashCell.self, forCellWithReuseIdentifier: "EmotionTrashCell")

        return collectionView
    }()

    private lazy var audioView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private lazy var deleteButton = MainButton(type: .delete)

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(goToFirstButton)
        addSubview(numberOfPage)
        addSubview(collectionView)
        addSubview(audioView)
        addSubview(deleteButton)

        goToFirstButton.snp.makeConstraints { make in
            make.width.equalTo(112)
            make.height.equalTo(28)
            make.leading.equalToSuperview().offset(256)
            make.top.equalToSuperview().offset(115)
        }

        numberOfPage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(303)
            make.top.equalTo(goToFirstButton.snp.bottom).offset(25)
        }

        collectionView.snp.makeConstraints { make in
            make.height.equalTo(373)
            make.top.equalTo(numberOfPage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }

        audioView.snp.makeConstraints { make in
            make.width.equalTo(304)
            make.height.equalTo(81)
            make.leading.equalToSuperview().offset(45)
            make.top.equalTo(collectionView.snp.bottom).offset(34)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
