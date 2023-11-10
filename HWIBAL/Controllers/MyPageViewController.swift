//
//  MyPageViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

final class MyPageViewController: RootViewController<MyPageView> {
    private var myPageSettingItems: [MyPageItem] = []
    private var selectedIndexPath: IndexPath?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
}

private extension MyPageViewController {
    func initializeUI() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self

        // MARK: - Navigation Setting

        navigationItem.title = "내 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = ColorGuide.main
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = ColorGuide.main

        let appearanceItem = MyPageItem(type: .appearance, title: "다크모드", isSwitchOn: true)
        let autoLoginItem = MyPageItem(type: .autoLogin, title: "자동 로그인", isSwitchOn: true)
        let autoVolatilizationDateItem = MyPageItem(type: .autoVolatilizationDate, title: "자동 휘발 주기 설정", isSwitchOn: false)
        let logoutItem = MyPageItem(type: .logout, title: "로그아웃", isSwitchOn: false)
        myPageSettingItems = [appearanceItem, autoLoginItem, autoVolatilizationDateItem, logoutItem]

        // MARK: - Update Title Label

        NotificationCenter.default.addObserver(self, selector: #selector(updateTitleLabel), name: NSNotification.Name("EmotionTrashUpdate"), object: nil)

        // MARK: - Action

        rootView.reportSummaryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPageToReport)))
    }
}

private extension MyPageViewController {
    @objc func updateTitleLabel() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.updateTitleLabel()
        }
    }
    
    @objc func myPageToReport() {
        let reportVC = ReportViewController()
        reportVC.modalPresentationStyle = .fullScreen
        present(reportVC, animated: true, completion: nil)
        print("🫵 클릭: 리포트 더보기")
    }
    
    @objc func settingButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
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

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageSettingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCustomCell.identifier, for: indexPath) as? MyPageCustomCell else {
            return UITableViewCell()
        }

        let myPageSettingItem = myPageSettingItems[indexPath.row]
        cell.configure(myPageSettingItem, SignInService.shared.signedInUser!)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let myPageSettingItem = myPageSettingItems[indexPath.row]

        switch myPageSettingItem.type {
        case .appearance:
            print("🫵 클릭: 화면모드")

        case .autoLogin:
            print("🫵 클릭: 자동 로그인")

        case .autoVolatilizationDate:
            print("🫵 클릭: 자동 휘발일 설정")
            let volatilizationDateSettingAlert = UIAlertController(title: "", message: "당신의 감정쓰레기를 며칠 후 불태워 드릴까요?", preferredStyle: .actionSheet)
            let days = [1, 3, 7]
            for day in days {
                let formattedDay = "\(day)일"
                let action = UIAlertAction(title: formattedDay, style: .default) { _ in
                    UserService.shared.updateUser(email: (SignInService.shared.signedInUser?.email)!, autoExpireDays: day)
                    print("\(day) 후 감정쓰레기를 태워 드립니다.")
                    UserDefaults.standard.set(day, forKey: "autoExpireDays_\(String(describing: SignInService.shared.signedInUser?.email))")
                    if let indexPath = self.selectedIndexPath,
                       let cell = tableView.cellForRow(at: indexPath) as? MyPageCustomCell
                    {
                        cell.updateDateLabel(formattedDay)
                    }
                    NotificationService.shared.autoDeleteNotification(day)
                }
                volatilizationDateSettingAlert.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            volatilizationDateSettingAlert.addAction(cancelAction)
            present(volatilizationDateSettingAlert, animated: true)
        
        case .logout:
            print("🫵 클릭: 로그아웃")
            let logoutAlert = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
                SignInService.shared.SetOffAutoSignIn((SignInService.shared.signedInUser?.email)!)
                UserDefaults.standard.set(false, forKey: "isLocked")
                self.goToSignInVC()
            }
            logoutAlert.addAction(action)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            logoutAlert.addAction(cancel)
            present(logoutAlert, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct MyPageItem {
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
