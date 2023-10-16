//
//  ReportViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit

final class ReportViewController: UIViewController {
    private let reportView = ReportView()
    private var ReportPageItems: [ReportPage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
}

private extension ReportViewController {
    func initializeUI() {
        view = reportView
        reportView.collectionView.dataSource = self
        reportView.collectionView.delegate = self
        
        let summaryReportItem = ReportPage(type: .summaryReport)
        let dayOfTheWeekReportItem = ReportPage(type: .dayOfTheWeekReport)
        let hourlyReportItem = ReportPage(type: .hourlyReport)
        ReportPageItems = [summaryReportItem, dayOfTheWeekReportItem, hourlyReportItem]
        
        reportView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
}

extension ReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReportPageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reportPage = ReportPageItems[indexPath.row]
        var cell: UICollectionViewCell

        switch reportPage.type {
        case .summaryReport:
            let totalCountCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportSummaryCell.identifier, for: indexPath) as! ReportSummaryCell
            totalCountCell.configure()
            cell = totalCountCell
        case .dayOfTheWeekReport:
            let dayOfTheWeekCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportDayOfTheWeekCell.identifier, for: indexPath) as! ReportDayOfTheWeekCell
            dayOfTheWeekCell.configure()
            cell = dayOfTheWeekCell
        case .hourlyReport:
            let timeZoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportTimeZoneCell.identifier, for: indexPath) as! ReportTimeZoneCell
            timeZoneCell.configure()
            cell = timeZoneCell
        }
        
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }
}

extension ReportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 538)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 65
    }
}

struct ReportPage {
    enum ItemType {
        case summaryReport
        case dayOfTheWeekReport
        case hourlyReport
    }

    let type: ItemType

    init(type: ItemType) {
        self.type = type
    }
}

