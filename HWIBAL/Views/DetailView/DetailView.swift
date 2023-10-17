//
//  DetailView.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import SnapKit
import UIKit

final class DetailView: UIView, RootView {
    private lazy var goToFirstButton: UIButton = {
        let button = UIButton()

        button.setTitle("맨 처음으로 ", for: .normal)
        button.titleLabel?.font = FontGuide.size14Bold
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "<-"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = ColorGuide.subButton
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true

        return button
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(goToFirstButton)

        goToFirstButton.snp.makeConstraints { make in
            make.width.equalTo(112)
            make.height.equalTo(28)
            make.leading.equalToSuperview().offset(256)
            make.top.equalToSuperview().offset(115)
        }
    }
}
