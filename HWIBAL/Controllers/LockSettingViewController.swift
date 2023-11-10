//
//  LockSettingViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit

class LockSettingViewController: RootViewController<LockSettingView> {
    private var lockSettingItems: [LockSettingItem] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
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
        lockSettingItems = [passwordLockItem]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

struct LockSettingItem {
    enum ItemType {
        case passwordLock
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

