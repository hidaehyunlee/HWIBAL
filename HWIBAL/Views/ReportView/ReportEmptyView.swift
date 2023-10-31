//
//  ReportEmptyView.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/30.
//

import UIKit
import SnapKit

final class ReportEmptyView: UIView {
    let closeButton = CloseButton(color: .white)
    
    let emptyHwibari: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hwibariopen01")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "앗..."
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     감정쓰레기가 없어서
                     리포트할 내용이 없어요.
                     """
        label.font = FontGuide.size16
        label.textColor = .white
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .systemBackground
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        addSubview(imageAndTitle)
        imageAndTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
