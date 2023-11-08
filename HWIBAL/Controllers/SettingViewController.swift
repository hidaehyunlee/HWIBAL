//
//  SettingViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/08.
//

import UIKit

final class SettingViewController: RootViewController<SettingView> {
    private var settingItems: [SettingItem] = []
    private var selectedIndexPath: IndexPath?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
}

private extension SettingViewController {
    func initializeUI() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
        // MARK: - Navigation Setting
        
        navigationItem.title = "앱 설정"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // MARK: - TableView Setting

        let appVersionItem = SettingItem(type: .appVersion, title: "앱 버전")
        let inquireItem = SettingItem(type: .inquire, title: "문의하기")
        let withdrawalItem = SettingItem(type: .withdrawal, title: "회원탈퇴")
        settingItems = [appVersionItem, inquireItem, withdrawalItem]

        // MARK: - Action

        rootView.termsOfUse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsOfUseTapped(_:))))
        rootView.privacyPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped(_:))))
    }
}

private extension SettingViewController {
    @objc func termsOfUseTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://translucent-globe-4fc.notion.site/54c990bf3c204c4ba4336a6779d890b1?pvs=4") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc func privacyPolicyTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://translucent-globe-4fc.notion.site/bab2c8cb9ba3413f82c71751910e66e9?pvs=4") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func goToSignInVC() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate
        {
            let signInViewController = SignInViewController()
            sceneDelegate.window?.rootViewController = signInViewController
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }

        let settingItem = settingItems[indexPath.row]
        cell.configure(settingItem)
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let settingItem = settingItems[indexPath.row]

        switch settingItem.type {
        case .appVersion:
            print("🫵 클릭: 앱 버전")
        case .inquire:
            print("🫵 클릭: 문의하기")
        case .withdrawal:
            print("🫵 클릭: 회원탈퇴")
            let witdrawalAlert = UIAlertController(title: "", message: "계정을 삭제하시겠습니까? 이 작업은 실행 취소할 수 없습니다.", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "회원탈퇴", style: .destructive) { _ in
                SignInService.shared.setWithdrawal()
                UserService.shared.deleteUser((SignInService.shared.signedInUser?.email)!)
                self.goToSignInVC()
            }
            witdrawalAlert.addAction(action)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            witdrawalAlert.addAction(cancel)
            present(witdrawalAlert, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

struct SettingItem {
    enum ItemType {
        case appVersion
        case inquire
        case withdrawal
    }

    let type: ItemType
    let title: String

    init(type: ItemType, title: String) {
        self.type = type
        self.title = title
    }
}

