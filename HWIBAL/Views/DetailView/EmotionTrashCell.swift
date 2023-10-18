//
//  EmotionTrashCell.swift
//  HWIBAL
//
//  Created by daelee on 10/18/23.
//

import SnapKit
import UIKit

class EmotionTrashCell: UICollectionViewCell, RootView {
    static let identifier = "EmotionTrashCell"
   
    // MARK: - UI를 데이터에 맞에 업데이트
    public func configure() {
        initializeUI()
        
        // MARK: - Title, SubTitle
    }
    
    // MARK: - 초기 UI 설정
    func initializeUI() {
        backgroundColor = ColorGuide.main
    }
}
