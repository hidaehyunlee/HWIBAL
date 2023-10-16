//
//  ReportDayOfTheWeekCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/16.
//

import UIKit
import SnapKit

class ReportDayOfTheWeekCell: UICollectionViewCell {
    static let identifier = "dayOfTheWeekCell"
    var mostDaysOfTheWeek = "월요일"
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
    
    public func configure() {
        title.text = """
                     \(mostDaysOfTheWeek)만 되면
                     바빠지는 내 감쓰
                     """
        subTitle.text = "다른 요일보다 평균 감쓰 개수가 많아요"
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
