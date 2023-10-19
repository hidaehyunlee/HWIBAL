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

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.itemSize = CarouselConst.itemSize
        layout.minimumLineSpacing = CarouselConst.itemSpacing
        layout.minimumInteritemSpacing = 0

        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)

        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(EmotionTrashCell.self, forCellWithReuseIdentifier: EmotionTrashCell.identifier)
        view.isPagingEnabled = false // 한 페이지의 넓이를 조절 할 수 없기 때문에 scrollViewWillEndDragging을 사용하여 구현
        view.contentInsetAdjustmentBehavior = .never // 내부적으로 safe area에 의해 가려지는 것을 방지하기 위해서 자동으로 inset조정해 주는 것을 비활성화
        view.contentInset = CarouselConst.collectionViewContentInset
        view.decelerationRate = .fast // 스크롤이 빠르게 되도록 (페이징 애니메이션같이 보이게하기 위함)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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
            make.height.equalTo(CarouselConst.itemSize.height)
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
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

// Carousel 애니메이션: itemSize, itemSpacing, insetX 정의
extension DetailView {
    enum CarouselConst {
        static let itemSize = CGSize(width: 307, height: 373)
        static let itemSpacing = 24.0

        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - itemSize.width) / 2.0
        }

        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        }
    }
}
