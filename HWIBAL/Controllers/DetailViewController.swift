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
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self

        rootView.totalPage = userEmotionTrashes.count

        rootView.goToFirstButton.addTarget(self, action: #selector(goToFirstButtonTapped), for: .touchUpInside)
    }

    @objc func goToFirstButtonTapped() {
        rootView.collectionView.setContentOffset(CGPoint(x: -DetailView.CarouselConst.insetX, y: 0), animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateNumberOfPageLabel(1)
        }
    }

    @objc func playPauseButtonTapped(sender: UIButton) {
        let index = sender.tag
        let userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!)
        let reversedIndex = userEmotionTrashes.count - 1 - index
        let data = userEmotionTrashes[reversedIndex]

        if let recording = data.recording, let filePath = recording.filePath {
            guard let audioURL = URL(string: filePath) else {
                print("Error: URL로 변환 실패")
                return
            }

            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: audioURL.path) {
                do {
                    player = try AVAudioPlayer(contentsOf: audioURL)
                    player?.prepareToPlay()
                    player?.delegate = self
                } catch {
                    print("플레이어 생성 Error: \(error)")
                }
            } else {
                print("Error: 파일이 존재하지 않음")
            }
        }
    }

    @objc func deleteButtonTapped(sender: UIButton) {
        let index = sender.tag
        let cellId = userEmotionTrashes[index].id

        AlertManager.shared.showAlert(on: self, title: "감정쓰레기 삭제", message: "당신의 이 감정을 불태워 드릴게요.", okCompletion: { _ in
            EmotionTrashService.shared.deleteEmotionTrash(SignInService.shared.signedInUser!, cellId!)
            NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
            self.navigationController?.popViewController(animated: true)
        })
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

        if let imageData = data.image, let image = UIImage(data: imageData) {
            cell.imageModalView.imageView.image = image
        } else {
            cell.imageModalView.imageView.image = nil
            cell.showImageButton.isHidden = true
        }

        if let recording = data.recording, let filePath = recording.filePath {
            cell.playPauseButton.isHidden = false
            cell.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
            cell.playPauseButton.tag = indexPath.item

            if let player = player {
                if player.isPlaying {
                    player.pause()
                    cell.playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
                } else {
                    player.play()
                    cell.playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                }
            }
        } else {
            cell.playPauseButton.isHidden = true
        }

        cell.daysAgoLabel.text = getDaysAgo(startDate: Date(), endDate: data.timestamp ?? Date()) // 몇일전인지 구함
        cell.textContentLabel.text = data.text

        rootView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        rootView.deleteButton.tag = indexPath.item

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
        // let cellId = userEmotionTrashes[indexPath.item].id
        // print("현재 cell id: \(cellId)") // 추후 삭제 구현시 확인을 위해 남겨둠
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

extension DetailViewController: AVAudioPlayerDelegate {
    // 오디오 파일이 끝나면 버튼 UI 업데이트하는 델리게이트 메서드
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            cell.playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
//        }
//    }
}

// extension DetailViewController: UICollectionViewDelegateFlowLayout {
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
// }
