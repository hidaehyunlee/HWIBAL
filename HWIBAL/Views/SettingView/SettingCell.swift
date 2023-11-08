//
//  SettingCell.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/08.
//

import UIKit

class SettingCell: UITableViewCell {
    static let identifier = "settingCustom"

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
    
    private let versionInfo: UILabel = {
        let label = UILabel()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        label.text = "\(appVersion)"
        label.textAlignment = .right
        label.font = FontGuide.size16
        label.textColor = ColorGuide.main
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
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
    
    public func configure(_ settingItem: SettingItem) {
        titleLabel.text = settingItem.title
        
        switch settingItem.type {
        case .appVersion:
            indicator.isHidden = true
        case .inquire:
            versionInfo.isHidden = true
        case .withdrawal:
            versionInfo.isHidden = true
        }
        initializeUI()
    }
    
    func initializeUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-23)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(versionInfo)
        versionInfo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }
    }
}
