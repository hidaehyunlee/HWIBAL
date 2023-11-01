//
//  ReportViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit

final class ReportViewController: RootViewController<ReportView> {
    private var ReportPageItems: [ReportPage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        
        if ReportService.shared.calculateEmotionTrashCount() == 0 {
            let emptyView = ReportEmptyView()
            view.addSubview(emptyView)
            emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            emptyView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        } else {
            initializeUI()
        }
    }
    
}

private extension ReportViewController {
    func initializeUI() {
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
        
        let summaryReportItem = ReportPage(type: .summaryReport)
        let dayOfTheWeekReportItem = ReportPage(type: .dayOfTheWeekReport)
        let hourlyReportItem = ReportPage(type: .hourlyReport)
        ReportPageItems = [summaryReportItem, dayOfTheWeekReportItem, hourlyReportItem]
        
        rootView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        rootView.goToFirstButton.addTarget(self, action: #selector(goToFirstButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func goToFirstButtonTapped() {
        rootView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateNumberOfPageLabel(1)
        }
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

extension ReportViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: rootView.collectionView.contentOffset, size: rootView.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = rootView.collectionView.indexPathForItem(at: visiblePoint) {
            let currentPage = indexPath.item + 1
            DispatchQueue.main.async { [weak self] in
                self?.rootView.updateNumberOfPageLabel(currentPage)
            }
        }
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

