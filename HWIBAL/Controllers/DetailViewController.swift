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
        return userEmotionTrashes.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionTrashCell.identifier, for: indexPath) as! EmotionTrashCell
    
        cell.initializeUI()

        let userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!)
        let reversedIndex = userEmotionTrashes.count - 1 - indexPath.item
        let data = userEmotionTrashes[reversedIndex]

        if let attributedTextData = data.attributedStringData {
            do {
                if let attributedText = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: attributedTextData) {
                    //  NSAttributedString에 커스텀 속성을 적용하여 라벨에 직접 설정
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: FontGuide.size16,
                        .foregroundColor: UIColor.white
                    ]
                    
                    let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
                    mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.length))

                    cell.textContentLabel.attributedText = mutableAttributedString
                } else {
                    print("Failed to unarchive NSAttributedString from data.")
                }
            } catch {
                print("Error unarchiving data: \(error.localizedDescription)")
            }
//            do {
//                if let unarchivedData = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: attributedTextData) {
//                    // 언아카이브된 NSAttributedString에서 이미지 및 크기 정보 가져오기
//                    let fullRange = NSRange(location: 0, length: unarchivedData.length)
//
//                    unarchivedData.enumerateAttribute(.attachment, in: fullRange, options: []) { value, range, stop in
//                        if let attachment = value as? NSTextAttachment {
//                            if let attachmentTextData = attachment.contents,
//                               let unarchivedText = String(data: attachmentTextData, encoding: .utf8) {
//                                // attachmentText를 textView.text에 할당하거나 원하는 처리 수행
//                                cell.textContentLabel.text = unarchivedText
//                            }
//                            // attachment에서 이미지 가져오기
//                            if let unarchivedImage = attachment.image {
//                                //print("Image: \(image)")
//                                cell.imageContentView.image = unarchivedImage
//                            }
//
//                            // attachment에서 크기 정보 가져오기
//                            let imageSize = attachment.bounds.size
//                            print("Image Size: \(imageSize)")
//                        }
//                    }
//                } else {
//                    print("Failed to unarchive NSAttributedString from data.")
//                }
//            } catch {
//                print("Error unarchiving data: \(error.localizedDescription)")
//            }
        } else {
            print("data.attributedStringData is nil")
        }
        
        if let recording = data.recording, let filePath = recording.filePath {
            cell.playPauseButton.isHidden = false
            cell.filePath = filePath // audioPlayer 대신 filePath를 설정합니다.
            cell.playPauseButton.addTarget(cell, action: #selector(cell.playPauseButtonTapped), for: .touchUpInside)
        } else {
            cell.playPauseButton.isHidden = true
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
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let cellId = userEmotionTrashes[indexPath.item].id
    //        print("현재 cell id: \(cellId)") // 추후 삭제 구현시 확인을 위해 남겨둠
    //    }
        
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
    
// extension DetailViewController: AVAudioPlayerDelegate {
//    // 오디오 파일이 끝나면 버튼 UI 업데이트하는 델리게이트 메서드
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            cell.playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
//        }
//    }
// }
