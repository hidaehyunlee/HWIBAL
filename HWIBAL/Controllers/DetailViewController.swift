//
//  DetailViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import SnapKit
import UIKit

final class DetailViewController: RootViewController<DetailView> {
    // private var prevIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }

    @objc func buttonTapped() {
        print("휘발 되었습니다.")
    }

    @objc func returnViewTapped() {
        print("Return 버튼이 탭되었습니다.")
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionTrashCell.identifier, for: indexPath) as! EmotionTrashCell

        cell.configure()
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true

        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    // 스크롤 멈출 때 호출, 스크롤이 셀의 중앙에 멈출 수 있도록 조정
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = DetailView.CarouselConst.itemSize.width + DetailView.CarouselConst.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)

        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}
