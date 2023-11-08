//
//  MyPageView.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import SnapKit
import UIKit

final class MyPageView: UIView, RootView {
    let reportSummaryView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.main
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 12
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var reportSummaryTitle: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size24Bold
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var reportSummarySubTitle: UILabel = {
        let label = UILabel()
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
        tableView.isScrollEnabled = false
        tableView.register(MyPageCustomCell.self, forCellReuseIdentifier: MyPageCustomCell.identifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeUI()
        updateTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .systemBackground
        
        addSubview(reportSummaryView)
        reportSummaryView.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(35 * UIScreen.main.bounds.height / 852)
            make.centerX.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(161)
        }
        
        reportSummaryView.addSubview(reportSummaryTitle)
        reportSummaryTitle.snp.makeConstraints { make in
            make.top.equalTo(reportSummaryView.snp.top).offset(30)
            make.leading.equalTo(reportSummaryView.snp.leading).offset(25)
        }
        
        reportSummaryView.addSubview(reportSummarySubTitle)
        reportSummarySubTitle.snp.makeConstraints { make in
            make.top.equalTo(reportSummaryTitle.snp.bottom).offset(7)
            make.leading.equalTo(reportSummaryView.snp.leading).offset(25)
        }
        
        reportSummaryView.addSubview(moreInfo)
        moreInfo.snp.makeConstraints { make in
            make.bottom.equalTo(reportSummaryView.snp.bottom).offset(-16)
            make.trailing.equalTo(reportSummaryView.snp.trailing).offset(-10)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(reportSummaryView.snp.bottom).offset(35 * UIScreen.main.bounds.height / 852)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    func updateTitleLabel() {
        reportSummaryTitle.text = """
                     가입 이후 작성한
                     감정쓰레기 \(ReportService.shared.calculateEmotionTrashCount())개
                     """
        
        switch ReportService.shared.calculateThisWeekEmotionTrashCount() {
        case let difference where difference > ReportService.shared.calculateLastWeekEmotionTrashCount():
            reportSummarySubTitle.text = "지난주보다 \(difference - ReportService.shared.calculateLastWeekEmotionTrashCount())개 더 썼어요"
        case let difference where difference < ReportService.shared.calculateLastWeekEmotionTrashCount():
            reportSummarySubTitle.text = "지난주보다 \(ReportService.shared.calculateLastWeekEmotionTrashCount() - difference)개 적게 썼어요"
        default:
            reportSummarySubTitle.text = "지난주와 같아요"
        }
    }
}
