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
    var timeZoneCount = 0 //ReportService.shared.calculateTimeZoneCount()
    var maxTimeZone = ""
    var maxCount = 0
    var averageCount = 0
    
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
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let timeZoneView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var fromTimeUnit: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14Bold
        label.textColor = ColorGuide.main
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        return label
    }()
    
    lazy var fromTime: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size75Heavy
        label.textColor = ColorGuide.main
        label.textAlignment = .left
        return label
    }()
    
    private lazy var fromTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fromTimeUnit, fromTime])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var untilTimeUnit: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size14Bold
        label.textColor = ColorGuide.main
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        return label
    }()
    
    lazy var untilTime: UILabel = {
        let label = UILabel()
        label.font = FontGuide.size75Heavy
        label.textColor = ColorGuide.main
        label.textAlignment = .left
        return label
    }()
    
    private lazy var untilTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [untilTimeUnit, untilTime])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var timeZoneStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fromTimeStackView, untilTimeStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var fromTimeLine: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.main
        return view
    }()
    
    private lazy var untilTimeLine: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.main
        return view
    }()
    
    public func configure() {
        // MARK: - initializeUI
        initializeUI()
        
        // MARK: - Title, SubTitle
//        for (timeZone, count) in timeZoneCount {
//            if count > maxCount {
//                maxCount = count
//                maxTimeZone = timeZone
//            }
//        }
        
        title.text = """
                     \(generateGreetingForHour(maxTimeZone))에
                     분주한 내 감정쓰레기
                     """
        subTitle.text = """
                        감정쓰레기 개수 \(maxCount)개
                        다른 시간대보다 감정쓰레기 개수가 많아요
                        """
        
        // MARK: - TimeZone
        generateForHourRange(maxTimeZone)
    }
    
    private func averageEmotionTrashCount() -> Int {
//        let totalValues = timeZoneCount.values.reduce(0, +)
//        averageCount = Int(Double(totalValues)) / timeZoneCount.count
        
        return 0
    }
    
    private func generateGreetingForHour(_ timeZone: String) -> String {
        var greeting = ""
        switch timeZone {
        case "8To11":
            greeting = "상쾌한 아침"
        case "11To15":
            greeting = "즐거운 점심"
        case "15To19":
            greeting = "따뜻한 오후"
        case "19To22":
            greeting = "즐거운 저녁"
        case "22To2":
            greeting = "센치한 밤"
        case "2To8":
            greeting = "고요한 새벽"
        default:
            greeting = "알 수 없는 시간"
        }
        return greeting
    }
    
    private func generateForHourRange(_ timeZone: String) {
        let (from, until, fromHour, untilHour) = {
            switch timeZone {
            case "8To11":
                return ("AM", "AM", 8, 11)
            case "11To15":
                return ("AM", "PM", 11, 15)
            case "15To19":
                return ("PM", "PM", 15, 19)
            case "19To22":
                return ("PM", "PM", 19, 22)
            case "22To2":
                return ("PM", "AM", 22, 2)
            case "2To8":
                return ("AM", "AM", 2, 8)
            default:
                return ("AM", "AM", 0, 0)
            }
        }()
        
        fromTimeUnit.text = from
        fromTime.text = "\(fromHour):00"
        untilTimeUnit.text = until
        untilTime.text = "\(untilHour):00"
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
        
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        subView.addSubview(timeZoneView)
        timeZoneView.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        timeZoneView.addSubview(fromTimeStackView)
        fromTimeStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
        }

        view.addSubview(untilTimeStackView)
        untilTimeStackView.snp.makeConstraints { make in
            make.top.equalTo(fromTimeStackView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-25)
        }

        view.addSubview(fromTimeLine)
        fromTimeLine.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.top.equalTo(fromTimeStackView.snp.top).offset(46)
            make.leading.equalTo(fromTimeStackView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }

        view.addSubview(untilTimeLine)
        untilTimeLine.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.top.equalTo(untilTimeStackView.snp.top).offset(45)
            make.leading.equalToSuperview()
            make.trailing.equalTo(untilTimeStackView.snp.leading).offset(-10)
        }
    }
}
