//
//  ReportSummaryCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit
import SnapKit
import DGCharts

class ReportSummaryCell: UICollectionViewCell {
    static let identifier = "summaryCell"
    var totalEmotionTrashCount = ReportService.shared.calculateEmotionTrashCount()
    var thisWeekEmotionTrashCount = ReportService.shared.calculateThisWeekEmotionTrashCount()
    var lastWeekEmotionTrashCount = ReportService.shared.calculateLastWeekEmotionTrashCount()
    var compareEmotionTrashCount = ReportService.shared.compareWeek()
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var title: UILabel =  {
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
    
    let chartView: BarChartView = {
        let chartView = BarChartView()
        chartView.isUserInteractionEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1
        chartView.xAxis.axisLineWidth = 0
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["이번주", "지난주"])
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = FontGuide.size16Bold
        chartView.xAxis.labelTextColor = ColorGuide.subButton
        
        chartView.leftAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.animate(yAxisDuration: 2, easingOption: .easeInBack)
        chartView.setViewPortOffsets(left: 10, top: 20, right: 10, bottom: 25)
        return chartView
    }()
    
    let unit: UILabel = {
        let label = UILabel()
        label.text = "단위: 개"
        label.font = FontGuide.size14
        label.textColor = ColorGuide.textHint
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
   
    public func configure() {
        // MARK: - initializeUI
        initializeUI()
        
        // MARK: - Title, SubTitle
        title.text = """
                     가입 이후 작성한
                     감정쓰레기 \(totalEmotionTrashCount)개
                     """
        
        switch thisWeekEmotionTrashCount {
        case let difference where difference > lastWeekEmotionTrashCount:
            subTitle.text = "지난주보다 \(difference - lastWeekEmotionTrashCount)개 더 썼어요"
        case let difference where difference < lastWeekEmotionTrashCount:
            subTitle.text = "지난주보다 \(lastWeekEmotionTrashCount - difference)개 적게 썼어요"
        default:
            subTitle.text = "지난주와 같아요"
        }
        
        // MARK: - Chart
        let totalEntry = BarChartDataEntry(x: 0, y: Double(thisWeekEmotionTrashCount))
        let averageEntry = BarChartDataEntry(x: 1, y: Double(lastWeekEmotionTrashCount))
        
        let dataSet = BarChartDataSet(entries: [totalEntry, averageEntry], label: "감정쓰레기 개수")
        dataSet.colors = [ColorGuide.main, ColorGuide.textHint]
        dataSet.valueColors = [ColorGuide.main, ColorGuide.textHint]
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(FontGuide.size32Heavy)
        
        chartView.data = data
        chartView.barData?.barWidth = 0.3
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
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
        
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.width.equalTo(295)
            make.top.equalTo(subTitle.snp.bottom).offset(60)
            make.bottom.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(unit)
        unit.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-13)
        }
    }
}
