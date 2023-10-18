//
//  DetailViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import SnapKit
import UIKit

final class DetailViewController: RootViewController<DetailView> {
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

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {

}
