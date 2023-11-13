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

final class DetailViewController: RootViewController<DetailView> {
    var centerCell: EmotionTrashCell?
    private lazy var userEmotionTrashes: [EmotionTrash] = []
    let numberOfItems = 256
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if let cell = rootView.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? EmotionTrashCell {
            centerCell = cell
            UIView.animate(withDuration: 0) {
                self.centerCell?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }
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
        return numberOfItems
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionTrashCell.identifier, for: indexPath) as! EmotionTrashCell
    
        cell.initializeUI()

        let userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!)
        let reversedIndex = userEmotionTrashes.count - 1 - (indexPath.item % userEmotionTrashes.count)
        let data = userEmotionTrashes[reversedIndex]
            
        if let imageData = data.image, let image = UIImage(data: imageData) {
            cell.imageContentView.image = image
            cell.imageContentView.isHidden = false
        } else {
            cell.imageContentView.image = nil
            cell.imageContentView.isHidden = true
        }
        
        if let recording = data.recording, let filePath = recording.filePath {
            cell.playPauseButton.isHidden = false
            cell.filePath = filePath  // audioPlayer 대신 filePath를 설정합니다.
            cell.playPauseButton.addTarget(cell, action: #selector(cell.playPauseButtonTapped), for: .touchUpInside)

        } else {
            cell.playPauseButton.isHidden = true
        }
            
        cell.daysAgoLabel.text = getDaysAgo(startDate: Date(), endDate: data.timestamp ?? Date()) // 몇일전인지 구함
        cell.textContentLabel.text = data.text
            
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
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
            
        let centerPoint = CGPoint(x: rootView.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: rootView.collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = rootView.collectionView.indexPathForItem(at: centerPoint) {
            centerCell = (rootView.collectionView.cellForItem(at: indexPath) as? EmotionTrashCell)
            centerCell?.transformToLarge()
            
            let userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!)
            if indexPath.item > 0 || indexPath.item < userEmotionTrashes.count {
                let prevCell = (rootView.collectionView.cellForItem(at: IndexPath(item: indexPath.item - 1, section: 0)) as? EmotionTrashCell)
                let nextCell = (rootView.collectionView.cellForItem(at: IndexPath(item: indexPath.item + 1, section: 0)) as? EmotionTrashCell)
                
                prevCell?.transformToStandard()
                nextCell?.transformToStandard()
            }
        }
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: rootView.collectionView.contentOffset, size: rootView.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
        if let indexPath = rootView.collectionView.indexPathForItem(at: visiblePoint) {
            let currentPage = (indexPath.item % userEmotionTrashes.count) + 1
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
    
//extension DetailViewController: AVAudioPlayerDelegate {
//    // 오디오 파일이 끝나면 버튼 UI 업데이트하는 델리게이트 메서드
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            cell.playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
//        }
//    }
//}
