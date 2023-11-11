//
//  DetailViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import AVFAudio
import AVFoundation
import SnapKit
import UIKit

var player: AVAudioPlayer?

final class DetailViewController: RootViewController<DetailView> {
    var cellsInitialized: [IndexPath: Bool] = [:]
    private var prevIndex: Int = 0
    private lazy var userEmotionTrashes: [EmotionTrash] = []
    var attributedStringFilePath: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!)

        if userEmotionTrashes.count == 0 {
            initEmptyDetailView()
        } else {
            initDetailView()
        }
    }

    private func initEmptyDetailView() {
        let emptyView = EmptyDetailView()

        view.addSubview(emptyView)

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func initDetailView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self

        rootView.totalPage = userEmotionTrashes.count

        rootView.goToFirstButton.addTarget(self, action: #selector(goToFirstButtonTapped), for: .touchUpInside)
    }

    @objc func goToFirstButtonTapped() {
        rootView.collectionView.setContentOffset(CGPoint(x: -DetailView.CarouselConst.insetX, y: -DetailView.CarouselConst.insetY), animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateNumberOfPageLabel(1)
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userEmotionTrashes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionTrashCell.identifier, for: indexPath) as! EmotionTrashCell

        if cellsInitialized[indexPath] == nil {
            cell.initializeUI()
            cellsInitialized[indexPath] = true
        }

        let userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!)
        let reversedIndex = userEmotionTrashes.count - 1 - indexPath.item
        let data = userEmotionTrashes[reversedIndex]

        if let attributedTextData = data.attributedStringData {
            do {
                if let attributedText = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: attributedTextData) {
                    cell.textContentLabel.attributedText = attributedText
                } else {
                    print("Failed to unarchive NSAttributedString from data.")
                }
            } catch {
                print("Error unarchiving data: \(error.localizedDescription)")
            }
        } else {
            print("data.attributedStringData is nil")
        }

        cell.daysAgoLabel.text = getDaysAgo(startDate: Date(), endDate: data.timestamp ?? Date()) // 몇일전인지 구함

        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true

        return cell
    }

    func getDaysAgo(startDate: Date, endDate: Date) -> String {
        let calendar = Calendar.current
        let startDay = calendar.component(.day, from: startDate)
        let endDay = calendar.component(.day, from: endDate)

        var daysAgo = ""
        if startDay != endDay {
            daysAgo = "\(startDay - endDay)일 전"
        } else {
            daysAgo = "오늘"
        }
        return daysAgo
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cellId = userEmotionTrashes[indexPath.item].id
//        print("현재 cell id: \(cellId)") // 추후 삭제 구현시 확인을 위해 남겨둠
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

    // 서온님께 여쭤보기
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

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
