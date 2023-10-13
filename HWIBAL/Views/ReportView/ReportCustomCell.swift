//
//  ReportCustomCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit

class ReportCustomCell: UICollectionViewCell {
    static let identifier = "reportCustomCell"
    var totalEmotionTrashCount = 234
    var averageEmotionTrashCount = 134
    var mostDaysOfTheWeek = "월요일"
    var mostTimeZone = "상쾌한 아침"
    var timeAverageTrashCount = 50
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.layer.cornerRadius = 12
//        view.clipsToBounds = true
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size24Bold
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.snp.makeConstraints { make in
            make.width.equalTo(180)
        }
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.snp.makeConstraints { make in
            make.width.equalTo(250)
        }
        return label
    }()
    
    public func configure(_ reportPage: ReportPage) {
        switch reportPage.type {
        case .totalCountReport:
            title.text = """
                         가입 이후 작성한
                         감쓰 \(totalEmotionTrashCount)개
                         """
            switch totalEmotionTrashCount {
            case let difference where difference > averageEmotionTrashCount:
                subTitle.text = "평균보다 \(difference - averageEmotionTrashCount)개 더 썼어요"
            case let difference where difference < averageEmotionTrashCount:
                subTitle.text = "평균보다 \(averageEmotionTrashCount - difference)개 적게 썼어요"
            default:
                subTitle.text = "평균과 같아요"
            }
        case .dayOfTheWeekReport:
            title.text = """
                         \(mostDaysOfTheWeek)만 되면
                         바빠지는 내 감쓰
                         """
            subTitle.text = "다른 요일보다 평균 감쓰 개수가 많아요"
        case .hourlyReport:
            title.text = """
                         \(mostTimeZone)에
                         분주한 내 감쓰
                         """
            subTitle.text = """
                            평균 감쓰 개수 \(timeAverageTrashCount)개
                            다른 시간대보다 감쓰 개수가 많아요
                            """
        }
        initializeUI()
    }
    
    func initializeUI() {
        backgroundColor = .white
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        view.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(25)
        }
    }
}

