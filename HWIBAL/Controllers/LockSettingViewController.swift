//
//  LockSettingViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit

class LockSettingViewController: RootViewController<LockSettingView> {
    private var lockSettingItems: [LockSettingItem] = []
    private var selectedIndexPath: IndexPath?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rootView.tableView.reloadData()
    }
}

private extension LockSettingViewController {
    func initializeUI() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
        // MARK: - Navigation Setting
        
        navigationItem.title = "잠금 설정"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // MARK: - TableView Setting

        let passwordLockItem = LockSettingItem(type: .passwordLock, title: "암호 잠금", isSwitchOn: true)
        let changePasswordItem = LockSettingItem(type: .changePassword, title: "암호 변경", isSwitchOn: false)
        lockSettingItems = [passwordLockItem, changePasswordItem]
        
//        if passwordLockItem.isSwitchOn {
//            let biometricsAuthItem = LockSettingItem(type: .biometricsAuth, title: "생체인증", isSwitchOn: true)
//            let changePasswordItem = LockSettingItem(type: .changePassword, title: "암호 변경", isSwitchOn: false)
//        lockSettingItems += [biometricsAuthItem, changePasswordItem]
//        }
    }
}

extension LockSettingViewController: LockSettingCellDelegate {
    func lockSettingSwitchToggled(isOn: Bool) {
        if isOn {
            let passwordSetupVC = PasswordSetupViewController()
            passwordSetupVC.modalPresentationStyle = .fullScreen
            present(passwordSetupVC, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(false, forKey: "isLocked")
        }
    }
    
    func biometricsAuthSwitchToggled(isOn: Bool) {
        if isOn {
            UserDefaults.standard.set(true, forKey: "isAllowedBiometricsAuth")
        } else {
            UserDefaults.standard.set(false, forKey: "isAllowedBiometricsAuth")
        }
    }
}

extension LockSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lockSettingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LockSettingCell.identifier, for: indexPath) as? LockSettingCell else {
            return UITableViewCell()
        }

        let settingItem = lockSettingItems[indexPath.row]
        cell.configure(settingItem)
        cell.selectionStyle = .none
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let lockSettingItem = lockSettingItems[indexPath.row]

        switch lockSettingItem.type {
        case .passwordLock:
            print("🫵 클릭: 암호 잠금")
//        case .biometricsAuth:
//            print("🫵 클릭: 생체인증")
        case .changePassword:
            print("🫵 클릭: 암호 변경")
            let passwordSetupVC = PasswordSetupViewController()
            passwordSetupVC.modalPresentationStyle = .fullScreen
            present(passwordSetupVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

struct LockSettingItem {
    enum ItemType {
        case passwordLock
//        case biometricsAuth
        case changePassword
    }

    let type: ItemType
    let title: String
    var isSwitchOn: Bool

    init(type: ItemType, title: String, isSwitchOn: Bool) {
        self.type = type
        self.title = title
        self.isSwitchOn = isSwitchOn
    }
}

