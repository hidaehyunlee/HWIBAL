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
    private var signedInUser = SignInService.shared.signedInUser!
    private lazy var userEmotionTrashes: [EmotionTrash] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self

        userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(signedInUser)
        rootView.totalPage = userEmotionTrashes.count

        bindDetailViewEvents()
    }

    func bindDetailViewEvents() {
        rootView.goToFirstButton.addTarget(self, action: #selector(goToFirstButtonTapped), for: .touchUpInside)
        rootView.playPauseButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }

//    func configureAudioPlayer(for indexPath: IndexPath, withFileName fileName: String) {
//        let urlString = Bundle.main.path(forResource: fileName, ofType: "mp3")
//        print("urlString: \(String(describing: urlString))") // test
//
//        guard let audioURL = Bundle.main.url(forResource: "hwibalAudio_1", withExtension: "mp3") else {
//            print("configureAudioPlayer Error: Could not find the audio file. \(fileName)")
//            return
//        }
//
//        do {
//            player = try AVAudioPlayer(contentsOf: audioURL, fileTypeHint: AVFileType.mp3.rawValue)
//            player?.prepareToPlay()
//        } catch {
//            print("Error creating audio player: \(error)")
//        }
//    }

    @objc func goToFirstButtonTapped() {
        rootView.collectionView.setContentOffset(CGPoint(x: -DetailView.CarouselConst.insetX, y: 0), animated: true)
    }

    @objc func playButtonTapped() {
        print("playButtonTapped")
//        let path = Bundle.main.path(forResource: "Info", ofType: ".plist") // 시뮬레이터 경로 알기 위함
//        print(path)

        // Bundle.main 이 아니라 파일디렉토리, 파일매니저 (유저 디렉토리를 생성해서 저장해야함)
        guard let audioURL = Bundle.main.url(forResource: "hwibalAudio_2", withExtension: "mp3") else {
            print("configureAudioPlayer Error: Could not find the audio file. fileName")
            return
        }

        do {
            player = try AVAudioPlayer(data: try! Data(contentsOf: audioURL))
            player?.prepareToPlay()
        } catch {
            print("Error creating audio player: \(error)")
        }

        if player?.isPlaying == true {
            player?.pause()
            rootView.playPauseButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            rootView.playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        }
    }

    @objc func deleteButtonTapped(sender: UIButton) {
        let index = sender.tag
        let cellId = userEmotionTrashes[index].id

        AlertManager.shared.showAlert(on: self, title: "감정쓰레기 삭제", message: "당신의 이 감정을 불태워 드릴게요.") { _ in
            EmotionTrashService.shared.deleteEmotionTrash(self.signedInUser, cellId!)
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
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

        let userEmotionTrashes = EmotionTrashService.shared.fetchTotalEmotionTrashes(signedInUser)
        let reversedIndex = userEmotionTrashes.count - 1 - indexPath.item
        let data = userEmotionTrashes[reversedIndex]

        if let imageData = data.image, let image = UIImage(data: imageData) {
            cell.emotionTrashBackView.backImageView.image = image
        } else {
            cell.emotionTrashBackView.backImageView.image = nil
            cell.showImageButton.isHidden = true
        }

        // if let audioFilePath = data.recording?.filePath {
        // let audioFileName = URL(fileURLWithPath: audioFilePath)
        // configureAudioPlayer(for: indexPath, withFileName: audioFilePath)

        // rootView.playPauseButton.isHidden = false
        // } else {}

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
