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
        label.textColor = .label
        label.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "일주일"
        label.textAlignment = .right
        label.font = FontGuide.size16
        label.textColor = ColorGuide.textHint
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
    
    let appearanceControl: UISwitch = {
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
    
    @objc func didTapSwitch(sender: UISwitch) {
        if sender.isOn {
            SignInService.shared.setSignedInUser((SignInService.shared.signedInUser?.email)!)
            UserService.shared.updateUser(email: (SignInService.shared.signedInUser?.email)!)
            print(SignInService.shared.isSignedIn())
        } else {
            SignInService.shared.SetOffAutoSignIn((SignInService.shared.signedInUser?.email)!)
            UserService.shared.updateUser(email: (SignInService.shared.signedInUser?.email)!)
            print(SignInService.shared.isSignedIn())
        }
    }
    
    @objc func didTapappearanceSwitch(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "isDarkMode")
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            UserDefaults.standard.set(false, forKey: "isDarkMode")
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    public func configure(_ settingItem: SettingItem, _ user: User) {
        titleLabel.text = settingItem.title
        switchControl.addTarget(self, action: #selector(didTapSwitch(sender:)), for: .valueChanged)
        appearanceControl.addTarget(self, action: #selector(didTapappearanceSwitch(sender:)), for: .valueChanged)
        
        switch settingItem.type {
        case .appearance:
            appearanceControl.isOn = UserDefaults.standard.bool(forKey: "isDarkMode")
            switchControl.isHidden = true
            indicator.isHidden = true
            dateLabel.isHidden = true
        case .autoLogin:
            appearanceControl.isHidden = true
            indicator.isHidden = true
            dateLabel.isHidden = true
            switchControl.isOn = UserDefaults.standard.bool(forKey: "isSignedIn")
        case .autoVolatilizationDate:
            appearanceControl.isHidden = true
            switchControl.isHidden = true
            dateLabel.text = "\(UserDefaults.standard.integer(forKey: "autoExpireDays_\(String(describing: SignInService.shared.signedInUser?.email))"))일"
            
        case .logout:
            appearanceControl.isHidden = true
            switchControl.isHidden = true
            dateLabel.isHidden = true
        }
        initializeUI()
    }

    func initializeUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(appearanceControl)
        appearanceControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }

        contentView.addSubview(switchControl)
        switchControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }

        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-23)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(indicator.snp.leading).offset(-10)
            make.width.equalTo(44)
        }
    }
    
    func updateDateLabel(_ text: String) {
        dateLabel.text = text
    }
}
