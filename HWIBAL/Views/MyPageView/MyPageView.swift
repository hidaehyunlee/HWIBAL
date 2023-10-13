//
//  MyPageView.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import SnapKit
import UIKit

final class MyPageView: UIView, RootView {
    var totalEmotionTrashCount = 234
    var averageEmotionTrashCount = 100
    
    private let reportSummuryView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.main
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var reportSummuryTitle: UILabel = {
        let label = UILabel()
        label.text = """
                     가입 이후 작성한
                     감쓰 \(self.totalEmotionTrashCount)개
                     """
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(60)
        }
        return label
    }()
    
    private lazy var reportSummurySubTitle: UILabel = {
        let label = UILabel()
        label.text = "평균보다 \(self.averageEmotionTrashCount)개 더 썼어요"
        label.font = FontGuide.size14
        label.textColor = .white
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        return label
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
        tableView.register(MyPageCustomCell.self, forCellReuseIdentifier: MyPageCustomCell.identifier)
        return tableView
    }()
    
    let cancelButton = MainButton(type: .withdrawal)

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
