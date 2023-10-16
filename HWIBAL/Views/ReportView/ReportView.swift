//
//  ReportView.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit
import SnapKit

final class ReportView: UIView, RootView {
    var currentPage = 1
    var totalPage = 3
    
    let closeButton = CloseButton(color: .white)
    
    let goToFirstButton: UIButton = {
        let button = UIButton()
        button.setTitle("맨 위로 ", for: .normal)
        button.setImage(UIImage(named: "up"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontGuide.size14Bold
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 14
        button.snp.makeConstraints { make in
            make.width.equalTo(78)
            make.height.equalTo(28)
        }
        return button
    }()
    
    lazy var numberOfPage: UILabel = {
        let label = UILabel()
        
        let currentPageText = "\(self.currentPage) "
        let totalPageText = "/ \(self.totalPage)"
        
        let attributedString = NSMutableAttributedString(string: currentPageText, attributes: [
            .font: FontGuide.size16Bold,
            .foregroundColor: UIColor.white
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
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ReportCustomCell.self, forCellWithReuseIdentifier: ReportCustomCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .black
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        addSubview(goToFirstButton)
        goToFirstButton.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(24)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        addSubview(numberOfPage)
        numberOfPage.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(38)
            make.trailing.equalToSuperview().offset(-35)
            make.height.equalTo(20)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(numberOfPage.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
