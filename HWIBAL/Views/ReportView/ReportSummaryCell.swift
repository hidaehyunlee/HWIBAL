//
//  ReportSummaryCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit
import SnapKit
import Charts

class ReportSummaryCell: UICollectionViewCell {
    static let identifier = "summaryCell"
    var totalEmotionTrashCount = 234
    var averageEmotionTrashCount = 134
    
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
