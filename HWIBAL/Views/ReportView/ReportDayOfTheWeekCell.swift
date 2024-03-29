//
//  ReportDayOfTheWeekCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/16.
//

import UIKit
import SnapKit
import DGCharts

class ReportDayOfTheWeekCell: UICollectionViewCell {
    static let identifier = "dayOfTheWeekCell"
    private var daysOfWeekCount = ReportService.shared.calculateDaysOfWeekCount()
    private var maxDay = ""
    private var maxCount = 0
    private var chartGenerated = false
    
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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let largeCircle: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorGuide.main
        label.font = FontGuide.size64Bold
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    private let daysOfWeekView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var daysOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private let rankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let rankTitle: UILabel = {
        let label = UILabel()
        label.text = "평균 감정쓰레기 개수 TOP3"
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let seperateLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var firstRankingDayOfTheWeek: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        return label
    }()
    
    var firstRankingCount: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .right
        label.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        return label
    }()
    
    private lazy var firstRank: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstRankingDayOfTheWeek, firstRankingCount])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 43
        return stackView
    }()
    
    var secondRankingDayOfTheWeek: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        return label
    }()
    
    var secondRankingCount: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .right
        label.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        return label
    }()
    
    private lazy var secondRank: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondRankingDayOfTheWeek, secondRankingCount])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 43
        return stackView
    }()
    
    var thirdRankingDayOfTheWeek: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        return label
    }()
    
    var thirdRankingCount: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14
        label.textColor = .black
        label.textAlignment = .right
        label.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        return label
    }()
    
    private lazy var thirdRank: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thirdRankingDayOfTheWeek, thirdRankingCount])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 43
        return stackView
    }()
    
    private lazy var rank: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstRank, secondRank, thirdRank])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    public func configure() {
        // MARK: - initializeUI
        initializeUI()
        
        // MARK: - Title, SubTitle
        for (day, count) in daysOfWeekCount {
            if count > maxCount {
                maxCount = count
                maxDay = day
            }
        }
        
        title.text = """
                     \(maxDay)요일만 되면
                     바빠지는 내 감정쓰레기
                     """
        subTitle.text = "다른 요일보다 평균 감정쓰레기 개수가 많아요"
        
        // MARK: - Day of The Week
        if !chartGenerated {
            generateChartForDayOfWeek()
            chartGenerated = true
        }
        
        // MARK: - Rank
        let sortedDaysOfWeekCount = daysOfWeekCount.sorted { $0.value > $1.value }

        if sortedDaysOfWeekCount.count >= 1 {
            firstRankingDayOfTheWeek.text = "1. \(sortedDaysOfWeekCount[0].key)요일"
            firstRankingCount.text = "\(sortedDaysOfWeekCount[0].value)개"
        }

        if sortedDaysOfWeekCount.count >= 2 {
            secondRankingDayOfTheWeek.text = "2. \(sortedDaysOfWeekCount[1].key)요일"
            secondRankingCount.text = "\(sortedDaysOfWeekCount[1].value)개"
        }

        if sortedDaysOfWeekCount.count >= 3 {
            thirdRankingDayOfTheWeek.text = "3. \(sortedDaysOfWeekCount[2].key)요일"
            thirdRankingCount.text = "\(sortedDaysOfWeekCount[2].value)개"
        }
    }
    
    private func generateChartForDayOfWeek() {
        var delay: TimeInterval = 0.0
        for day in ["일", "월", "화", "수", "목", "금", "토"] {
            let isMaxDay = day == maxDay
            let circleLabel: UILabel
            if isMaxDay {
                circleLabel = largeCircle
                let diameter = UIScreen.main.bounds.width - 278 // 셀 마진 24, 컨텐츠 마진 25, 작은 circle 지름 30
                circleLabel.layer.cornerRadius = diameter/2
                circleLabel.snp.makeConstraints { make in
                    make.width.height.equalTo(diameter)
                }
            } else {
                circleLabel = {
                    let label = UILabel()
                    label.backgroundColor = ColorGuide.inputLine
                    label.font = FontGuide.size16Bold
                    label.textColor = .black
                    label.textAlignment = .center
                    label.layer.cornerRadius = 15
                    label.clipsToBounds = true
                    label.snp.makeConstraints { make in
                        make.width.height.equalTo(30)
                    }
                    return label
                }()
            }
            circleLabel.text = day
            
            circleLabel.alpha = 0.0
            UIView.animate(withDuration: 0.3, delay: delay, options: [], animations: {
                circleLabel.alpha = 1.0
            }, completion: nil)
            
            daysOfWeekStackView.addArrangedSubview(circleLabel)
            delay += 0.3
        }
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
        
        view.addSubview(rankView)
        rankView.snp.makeConstraints { make in
            make.height.equalTo(111)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        rankView.addSubview(rankTitle)
        rankTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        rankView.addSubview(seperateLineView)
        seperateLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(rankTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }

        rankView.addSubview(rank)
        rank.snp.makeConstraints { make in
            make.top.equalTo(seperateLineView.snp.bottom).offset(13)
            make.leading.trailing.bottom.equalToSuperview()
        }

        view.addSubview(daysOfWeekView)
        daysOfWeekView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(rankView.snp.top)
        }
        
        daysOfWeekView.addSubview(daysOfWeekStackView)
        daysOfWeekStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
}
