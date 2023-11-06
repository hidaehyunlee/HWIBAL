//
//  DetailView.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import AVFAudio
import SnapKit
import UIKit

final class DetailView: UIView, RootView {
    lazy var goToFirstButton: UIButton = {
        let button = UIButton()

        button.setTitle(" 맨 처음으로", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = FontGuide.size14Bold

        if let image = UIImage(named: "<-") {
            let colorImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(colorImage, for: .normal)
            button.tintColor = UIColor.label
        }
        button.semanticContentAttribute = .forceLeftToRight

        return button
    }()

    var currentPage = 1
    var totalPage: Int = 0 {
        didSet {
            let currentPageText = "\(currentPage) "
            let totalPageText = "/ \(totalPage)"

            let attributedString = NSMutableAttributedString(string: currentPageText, attributes: [
                .font: FontGuide.size16Bold,
                .foregroundColor: UIColor.label
            ])

            let totalPageAttributedString = NSAttributedString(string: totalPageText, attributes: [
                .font: FontGuide.size16Bold,
                .foregroundColor: ColorGuide.textHint
            ])

            attributedString.append(totalPageAttributedString)

            numberOfPageLabel.attributedText = attributedString
            numberOfPageLabel.textAlignment = .right
        }
    }

    lazy var numberOfPageLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CarouselConst.itemSize
        layout.minimumLineSpacing = CarouselConst.itemSpacing
        layout.minimumInteritemSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    lazy var playPauseButton: UIButton = {
        let button = UIButton()

        let image = UIImage(named: "play")
        button.setBackgroundImage(image, for: .normal)
        button.isHidden = true

        return button
    }()

    lazy var deleteButton = MainButton(type: .delete)

    private lazy var DetailComponents: UIStackView = {
        let topStackView = UIStackView(arrangedSubviews: [goToFirstButton, numberOfPageLabel])
        topStackView.axis = .horizontal
        topStackView.spacing = 140

        let stackView = UIStackView(arrangedSubviews: [topStackView, collectionView, audioView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 48)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-40)
        }

        addSubview(testView)
        testView.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(deleteButton.snp.top)
        }

        testView.addSubview(goToFirstButton)
        goToFirstButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(54)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }

        testView.addSubview(numberOfPageLabel)
        numberOfPageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-54)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }

        testView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(goToFirstButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(440)
        }

        testView.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-58)
            make.size.equalTo(36)
        }
    }

    // ✏️ 이벤트버스로 값 넘겨서 DetailVC로 옮겨야함
    func updateNumberOfPageLabel(_ currentPage: Int) {
        let currentPageText = "\(currentPage) "
        let totalPageText = "/ \(totalPage)"

        let attributedString = NSMutableAttributedString(string: currentPageText, attributes: [
            .font: FontGuide.size16Bold,
            .foregroundColor: UIColor.label
        ])

        let totalPageAttributedString = NSAttributedString(string: totalPageText, attributes: [
            .font: FontGuide.size16Bold,
            .foregroundColor: ColorGuide.textHint
        ])

        attributedString.append(totalPageAttributedString)

        numberOfPageLabel.attributedText = attributedString
    }
}

// Carousel 애니메이션: itemSize, itemSpacing, insetX 정의
extension DetailView {
    enum CarouselConst {
        static let itemSize = CGSize(width: 307, height: 440)
        static let itemSpacing = 24.0

        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - itemSize.width) / 2.0
        }

        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        }
    }
}
