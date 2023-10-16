//
//  ReportTimeZoneCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/16.
//

import UIKit
import SnapKit

class ReportTimeZoneCell: UICollectionViewCell {
    static let identifier = "timeZoneCell"
    var mostTimeZone = "상쾌한 아침"
    var timeAverageTrashCount = 50
    
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
                     \(mostTimeZone)에
                     분주한 내 감쓰
                     """
        subTitle.text = """
                        평균 감쓰 개수 \(timeAverageTrashCount)개
                        다른 시간대보다 감쓰 개수가 많아요
                        """
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
