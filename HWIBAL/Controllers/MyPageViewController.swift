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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        
        ReportService.shared.fetchReports()
    }
}

private extension MyPageViewController {
    func initializeUI() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
        // MARK: - Navigation Setting
        navigationItem.title = "내 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearanceItem = SettingItem(type: .appearance, title: "다크모드", isSwitchOn: true)
        let autoLoginItem = SettingItem(type: .autoLogin, title: "자동 로그인", isSwitchOn: true)
        let autoVolatilizationDateItem = SettingItem(type: .autoVolatilizationDate, title: "자동 휘발 주기 설정", isSwitchOn: false)
        let logoutItem = SettingItem(type: .logout, title: "로그아웃", isSwitchOn: false)
        settingsItems = [appearanceItem, autoLoginItem, autoVolatilizationDateItem, logoutItem]
        
        // MARK: - Update Title Label
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitleLabel), name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
        
        // MARK: - Action
        rootView.withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
        rootView.reportSummaryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPageToReport)))
    }
    
    @objc func updateTitleLabel() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateTitleLabel()
        }
        
    }
}

private extension MyPageViewController {
    @objc func withdrawalButtonTapped() {
        print("🫵 클릭: 회원탈퇴")
        let witdrawalAlert = UIAlertController(title: "", message: "계정을 삭제하시겠습니까? 이 작업은 실행 취소할 수 없습니다.", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "회원탈퇴", style: .destructive) { _ in
            FireStoreManager.shared.deleteUser(userId: FireStoreManager.shared.signInUser!.id)
//            SignInService.shared.setWithdrawal()
//            UserService.shared.deleteUser((SignInService.shared.signedInUser?.email)!)
            self.goToSignInVC()
        }
        witdrawalAlert.addAction(action)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        witdrawalAlert.addAction(cancel)
        present(witdrawalAlert, animated: true)
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
        cell.configure(settingItem, FireStoreManager.shared.signInUser!)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let settingItem = settingsItems[indexPath.row]

        switch settingItem.type {
            case .appearance:
            print("🫵 클릭: 화면모드")            
            break
                
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
                    FireStoreManager.shared.updateUser(userId: FireStoreManager.shared.signInUser!.id, autoExpireDays: day)
//                    UserService.shared.updateUser(email: (SignInService.shared.signedInUser?.email)!, autoExpireDays: day)
                    print("\(day) 후 감정쓰레기를 태워 드립니다.")
//                    UserDefaults.standard.set(day, forKey: "autoExpireDays_\(String(describing: SignInService.shared.signedInUser?.email))")
                    if let indexPath = self.selectedIndexPath,
                       let cell = tableView.cellForRow(at: indexPath) as? MyPageCustomCell {
                        cell.updateDateLabel(formattedDay)
                    }
//                    EmotionTrashService.shared.startAutoDeleteTask(day)
                    // 백그라운드 태스크 실행
//                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                        appDelegate.startAutoDeleteTask()
//                    }
                }
                volatilizationDateSettingAlert.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            volatilizationDateSettingAlert.addAction(cancelAction)
            present(volatilizationDateSettingAlert, animated: true)
            break
            
            case .logout:
            print("🫵 클릭: 로그아웃")
//            SignInService.shared.SetOffAutoSignIn((SignInService.shared.signedInUser?.email)!)
            goToSignInVC()
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct SettingItem {
    enum ItemType {
        case appearance
        case autoLogin
        case autoVolatilizationDate
        case logout
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
