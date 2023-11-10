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
//    func biometricsAuthSwitchToggled(isOn: Bool)
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
    
    let biometricsAuthSwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = ColorGuide.main
        switchControl.isOn = true
        return switchControl
    }()
    
    private let indicator: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: ">") {
            let colorImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(colorImage, for: .normal)
            button.tintColor = UIColor.label
        }
        button.isUserInteractionEnabled = false
        return button
    }()
    
    @objc func didTapLockSettingSwitch(sender: UISwitch) {
        delegate?.lockSettingSwitchToggled(isOn: sender.isOn)
    }
    
//    @objc func didTapBiometricsAuthSwitch(sender: UISwitch) {
//        delegate?.biometricsAuthSwitchToggled(isOn: sender.isOn)
//    }
    
    public func configure(_ settingItem: LockSettingItem) {
        titleLabel.text = settingItem.title
        switchControl.addTarget(self, action: #selector(didTapLockSettingSwitch(sender:)), for: .valueChanged)
//        biometricsAuthSwitchControl.addTarget(self, action: #selector(didTapBiometricsAuthSwitch(sender:)), for: .valueChanged)
        
        switch settingItem.type {
        case .passwordLock:
            switchControl.isOn = UserDefaults.standard.bool(forKey: "isLocked")
//            biometricsAuthSwitchControl.isHidden = true
            indicator.isHidden = true
//        case .biometricsAuth:
//            switchControl.isHidden = true
//            biometricsAuthSwitchControl.isOn = UserDefaults.standard.bool(forKey: "isAllowedBiometricsAuth")
//            indicator.isHidden = true
        case .changePassword:
            switchControl.isHidden = true
//            biometricsAuthSwitchControl.isHidden = true
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
        
//        contentView.addSubview(biometricsAuthSwitchControl)
//        biometricsAuthSwitchControl.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().offset(-30)
//        }
        
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-23)
            make.width.height.equalTo(24)
        }
    }
}
