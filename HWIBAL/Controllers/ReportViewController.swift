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
        
        let totalCountReportItem = ReportPage(type: .totalCountReport, title: "", subTitle: "")
        let dayOfTheWeekReportItem = ReportPage(type: .dayOfTheWeekReport, title: "", subTitle: "")
        let hourlyReportItem = ReportPage(type: .hourlyReport, title: "", subTitle: "")
        ReportPageItems = [totalCountReportItem, dayOfTheWeekReportItem, hourlyReportItem]
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportCustomCell.identifier, for: indexPath) as! ReportCustomCell
        let totalCountReport = ReportPageItems[indexPath.row]
        cell.configure(totalCountReport)
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
        case totalCountReport
        case dayOfTheWeekReport
        case hourlyReport
    }

    let type: ItemType
    let title: String
    let subTitle: String

    init(type: ItemType, title: String, subTitle: String) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
    }
}

