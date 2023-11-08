//
//  SettingViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/08.
//

import UIKit
import MessageUI

final class SettingViewController: RootViewController<SettingView> {
    private var settingItems: [SettingItem] = []
    private var selectedIndexPath: IndexPath?
    let inquireVC = MFMailComposeViewController()

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
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
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
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            guard let unwrappedID = SignInService.shared.signedInUser?.id else { return }
            
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                composeVC.setToRecipients(["hwibari@gmail.com"])
                composeVC.setSubject("[아휘발] 문의하기")
                composeVC.setMessageBody("""
                                         문의하실 사항을 아래 서식에 맞추어 상세히 기입해주세요.
                                         
                                         문의 유형:
                                         문의 내용:
                                         
                                         App Version: \(appVersion)
                                         Device: \(UIDevice().getModelName())
                                         OS: \(UIDevice().getOsVersion())
                                         UserID: \(unwrappedID)
                                         
                                         """,
                                         isHTML: false)
                
                self.present(composeVC, animated: true, completion: nil)
                
            }
            else {
                self.showSendMailErrorAlert()
            }
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

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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

