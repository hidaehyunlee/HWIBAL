//
//  DetailViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import SnapKit
import UIKit

final class DetailViewController: RootViewController<DetailView> {
    var cellsInitialized: [IndexPath: Bool] = [:]
    private var prevIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self

        bindDetailViewEvents()
    }

    func bindDetailViewEvents() {
        rootView.goToFirstButton.addTarget(self, action: #selector(goToFirstButtonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        print("휘발 되었습니다.")
    }

    @objc func goToFirstButtonTapped() {
        rootView.collectionView.setContentOffset(CGPoint(x: -DetailView.CarouselConst.insetX, y: 0), animated: true)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionTrashCell.identifier, for: indexPath) as! EmotionTrashCell

        if cellsInitialized[indexPath] == nil {
            cell.initializeUI()
            cellsInitialized[indexPath] = true
        }

        let data = testData[indexPath.item]

        if let imageData = data.image, let image = UIImage(data: imageData) {
            cell.emotionTrashBackView.backImageView.image = image
        } else {
            cell.emotionTrashBackView.backImageView.image = nil
        }
        cell.daysAgoLabel.text = getDaysAgo(startDate: Date(), endDate: data.timestamp) // 몇일전인지 구함
        cell.textContentLabel.text = data.text

        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }

    func getDaysAgo(startDate: Date, endDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        var daysAgo = ""

        if let days = components.day {
            if days == 0 {
                daysAgo = "오늘"
                return daysAgo
            } else {
                daysAgo = String(days) + "일전"
                return daysAgo
            }
        } else {
            print("Error: getDaysAgo")
            return daysAgo
        }
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 특정 셀이 선택되었을 때 실행할 작업을 정의합니다.
        let selectedData = testData[indexPath.item] // 선택된 셀에 대한 데이터 가져오기
        print("Selected cell data: \(selectedData)")
    }

    // 스크롤이 멈추면 호출되며, 스크롤이 셀의 중앙에 멈추도록 함
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let cellWidth = DetailView.CarouselConst.itemSize.width + DetailView.CarouselConst.itemSpacing
        let index = round((targetContentOffset.pointee.x + scrollView.contentInset.left) / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: rootView.collectionView.contentOffset, size: rootView.collectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        if let indexPath = rootView.collectionView.indexPathForItem(at: visiblePoint) {
//            let currentPage = indexPath.item + 1
//            DispatchQueue.main.async { [weak self] in
//                self?.rootView.updateNumberOfPageLabel(currentPage)
//            }
//        }
//    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
//    // 셀 줌 인/아웃을 위한 스크롤 이벤트 처리
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let collectionView = rootView.collectionView
//        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
//        let offsetX = collectionView.contentOffset.x
//        let index = (offsetX + collectionView.contentInset.left) / cellWidthIncludeSpacing
//        let roundedIndex = round(index)
//
//        if Int(roundedIndex) != prevIndex {
//            if let preCell = collectionView.cellForItem(at: IndexPath(item: prevIndex, section: 0)) {
//                transform(cell: preCell, isFocus: false)
//            }
//            if let currentCell = collectionView.cellForItem(at: IndexPath(item: Int(roundedIndex), section: 0)) {
//                transform(cell: currentCell, isFocus: true)
//            }
//            prevIndex = Int(roundedIndex)
//        }
//    }

//    // 셀 확대/축소
//    private func transform(cell: UICollectionViewCell, isFocus: Bool) {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//            if isFocus {
//                cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                // 셀 내부 하위 뷰도 같이 커지는 문제 해결해야함
//                // 양 옆 inset 해결해야함
//            } else {
//                cell.transform = .identity
//            }
//        }, completion: nil)
//    }
}
