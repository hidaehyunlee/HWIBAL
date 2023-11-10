//
//  LockSettingCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit
import SnapKit

protocol LockSettingCellDelegate: AnyObject {
    func lockSettingSwitchToggled(isOn: Bool)
}

class LockSettingCell: UITableViewCell {
    static let identifier = "lockSettingCustom"
    weak var delegate: LockSettingCellDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = FontGuide.size16Bold
        label.textColor = .label
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
    }()

    let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = ColorGuide.main
        switchControl.isOn = true
        return switchControl
    }()
    
    @objc func didTapLockSettingSwitch(sender: UISwitch) {
        delegate?.lockSettingSwitchToggled(isOn: sender.isOn)
    }
    
    public func configure(_ settingItem: LockSettingItem) {
        titleLabel.text = settingItem.title
        switchControl.addTarget(self, action: #selector(didTapLockSettingSwitch(sender:)), for: .valueChanged)
        
        switch settingItem.type {
        case .passwordLock:
            switchControl.isOn = UserDefaults.standard.bool(forKey: "isLocked")
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
    }
}
