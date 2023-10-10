//
//  MyPageView.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import SnapKit
import UIKit

final class SettingView: UIView, RootView {
    private lazy var label = {
        let label = UILabel()
        label.text = "MyPage Screen"
        label.sizeToFit()
        return label
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
