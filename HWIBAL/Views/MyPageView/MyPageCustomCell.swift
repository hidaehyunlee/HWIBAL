//
//  MyPageCustomCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/12.
//

import UIKit

class MyPageCustomCell: UITableViewCell {
    static let identifier = "settingCustom"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = FontGuide.size16Bold
        label.textColor = ColorGuide.black
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
    }()

    let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = ColorGuide.main
        return switchControl
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public func configure(_ settingItem: SettingItem) {
        titleLabel.text = settingItem.title

        switch settingItem.type {
        case .autoLogin:
            switchControl.isHidden = false
            iconImageView.isHidden = true
            switchControl.isOn = settingItem.isSwitchOn
        case .autoVolatilizationDate, .logout:
            switchControl.isHidden = true
            iconImageView.isHidden = false
            iconImageView.image = settingItem.icon
        }
        initializeUI()
    }

    func initializeUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }

        contentView.addSubview(switchControl)
        switchControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }

        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.width.height.equalTo(24)
        }
    }
}
