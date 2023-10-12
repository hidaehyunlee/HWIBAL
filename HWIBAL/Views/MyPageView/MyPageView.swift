//
//  MyPageView.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import SnapKit
import UIKit

final class MyPageView: UIView, RootView {
    private let reportSummuryView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.main
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let firstTitle: UILabel = {
        let label = UILabel()
        label.text = "가입 이후 작성한"
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(29)
        }
        return label
    }()
    
    private let secondTitle: UILabel = {
        let label = UILabel()
        label.text = "감쓰"
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(29)
        }
        return label
    }()
    
    private let totalEmotionTrashCount: UILabel = {
        let label = UILabel()
        label.text = "234"
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(29)
        }
        return label
    }()
    
    private let unitTitle: UILabel = {
        let label = UILabel()
        label.text = "개"
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(29)
        }
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondTitle, totalEmotionTrashCount, unitTitle])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var reportSummuryTitle: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstTitle, titleStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    private let firstSubTitle: UILabel = {
        let label = UILabel()
        label.text = "평균보다"
        label.font = FontGuide.size14
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        return label
    }()
    
    private let averageEmotionTrashCount: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.font = FontGuide.size14
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        return label
    }()
    
    private let secondSubTitle: UILabel = {
        let label = UILabel()
        label.text = "개 더 썼어요"
        label.font = FontGuide.size14
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        return label
    }()
    
    private lazy var reportSummurySubTitle: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstSubTitle, averageEmotionTrashCount, secondSubTitle])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let moreTitle: UILabel = {
        let label = UILabel()
        label.text = "더보기"
        label.font = FontGuide.size16Bold
        label.textColor = .black
        label.textAlignment = .right
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
    }()
    
    private let moreImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ">")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        return imageView
    }()
    
    private lazy var moreInfo: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [moreTitle, moreImage])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingCustomCell.self, forCellReuseIdentifier: SettingCustomCell.identifier)
        return tableView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        let attributedText = NSAttributedString(string: "회원탈퇴", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedText, for: .normal)
        button.titleLabel?.font = FontGuide.size16
        button.setTitleColor(ColorGuide.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = ColorGuide.inputLine.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        return button
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
        
        addSubview(reportSummuryView)
        reportSummuryView.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(345)
            make.height.equalTo(161)
        }
        
        reportSummuryView.addSubview(reportSummuryTitle)
        reportSummuryTitle.snp.makeConstraints { make in
            make.top.equalTo(reportSummuryView.snp.top).offset(30)
            make.leading.equalTo(reportSummuryView.snp.leading).offset(24)
        }
        
        reportSummuryView.addSubview(reportSummurySubTitle)
        reportSummurySubTitle.snp.makeConstraints { make in
            make.top.equalTo(reportSummuryTitle.snp.bottom).offset(7)
            make.leading.equalTo(reportSummuryView.snp.leading).offset(24)
        }
        
        reportSummuryView.addSubview(moreInfo)
        moreInfo.snp.makeConstraints { make in
            make.bottom.equalTo(reportSummuryView.snp.bottom).offset(-16)
            make.trailing.equalTo(reportSummuryView.snp.trailing).offset(-10)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(reportSummuryView.snp.bottom).offset(50)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
