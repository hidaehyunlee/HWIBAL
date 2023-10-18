//
//  MyPageViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

final class MyPageViewController: RootViewController<MyPageView> {
    private var settingsItems: [SettingItem] = []
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
    }
}

private extension MyPageViewController {
    func initializeUI() {
        view = rootView
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
        // MARK: - Navigation Setting
        navigationItem.title = "내 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let autoLoginItem = SettingItem(type: .autoLogin, title: "자동 로그인",isSwitchOn: true)
        let autoVolatilizationDateItem = SettingItem(type: .autoVolatilizationDate, title: "자동 휘발일 설정", icon: UIImage(named: ">"), isSwitchOn: false)
        let logoutItem = SettingItem(type: .logout, title: "로그아웃", icon: UIImage(named: ">"), isSwitchOn: false)
        settingsItems = [autoLoginItem, autoVolatilizationDateItem, logoutItem]
        
        // MARK: - Action
        rootView.withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
        rootView.reportSummaryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPageToReport)))
    }
}

private extension MyPageViewController {
    @objc func withdrawalButtonTapped() {
        print("🫵 클릭: 회원탈퇴")
        SignInService.shared.setWithdrawal()
        UserService.shared.deleteUser((SignInService.shared.signedInUser?.email)!)
        goToSignInVC()
    }
    
    @objc func myPageToReport() {
        let reportVC = ReportViewController()
        reportVC.modalPresentationStyle = .fullScreen
        present(reportVC, animated: true, completion: nil)
        print("🫵 클릭: 리포트 더보기")
    }
    
    func goToSignInVC() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let signInViewController = SignInViewController()
            sceneDelegate.window?.rootViewController = signInViewController
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCustomCell.identifier, for: indexPath) as? MyPageCustomCell else {
            return UITableViewCell()
        }

        let settingItem = settingsItems[indexPath.row]
        cell.configure(settingItem, SignInService.shared.signedInUser!)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let settingItem = settingsItems[indexPath.row]

        switch settingItem.type {
            case .autoLogin:
            print("🫵 클릭: 자동 로그인")
            break
            
            case .autoVolatilizationDate:
            print("🫵 클릭: 자동 휘발일 설정")
            let volatilizationDateSettingAlert = UIAlertController(title: "", message: "당신의 감정쓰레기를 며칠 후 불태워 드릴까요?", preferredStyle: .actionSheet)
            let days = [1, 3, 7]
            for day in days {
                let formattedDay = "\(day)일"
                let action = UIAlertAction(title: formattedDay, style: .default) { _ in
                    UserService.shared.updateUser(email: (SignInService.shared.signedInUser?.email)!, autoExpireDays: Int64(day))
                    print("\(day) 후 감정쓰레기를 태워 드립니다.")
                    if let indexPath = self.selectedIndexPath,
                       let cell = tableView.cellForRow(at: indexPath) as? MyPageCustomCell {
                        cell.updateDateLabel(formattedDay)
                    }
                }
                volatilizationDateSettingAlert.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            volatilizationDateSettingAlert.addAction(cancelAction)
            present(volatilizationDateSettingAlert, animated: true)
            break
            
            case .logout:
            print("🫵 클릭: 로그아웃")
            SignInService.shared.SetOffAutoSignIn((SignInService.shared.signedInUser?.email)!)
            goToSignInVC()
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct SettingItem {
    enum ItemType {
        case autoLogin
        case autoVolatilizationDate
        case logout
    }

    let type: ItemType
    let title: String
    let icon: UIImage?
    var isSwitchOn: Bool

    init(type: ItemType, title: String, icon: UIImage? = nil, isSwitchOn: Bool) {
        self.type = type
        self.title = title
        self.icon = icon
        self.isSwitchOn = isSwitchOn
    }
}
