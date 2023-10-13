//
//  MyPageViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

final class MyPageViewController: RootViewController<MyPageView> {
    private let myPageView = MyPageView()
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
        view = myPageView
        myPageView.tableView.dataSource = self
        myPageView.tableView.delegate = self
        
        // MARK: - Navigation Setting
        navigationItem.title = "내 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let autoLoginItem = SettingItem(type: .autoLogin, title: "자동 로그인",isSwitchOn: true)
        let autoVolatilizationDateItem = SettingItem(type: .autoVolatilizationDate, title: "자동 휘발일 설정", icon: UIImage(named: ">"), isSwitchOn: false)
        let logoutItem = SettingItem(type: .logout, title: "로그아웃", icon: UIImage(named: ">"), isSwitchOn: false)
        settingsItems = [autoLoginItem, autoVolatilizationDateItem, logoutItem]
        
        // MARK: - Action
        myPageView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        myPageView.reportSummuryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPageToReport)))
    }
}

private extension MyPageViewController {
    @objc func cancelButtonTapped() {
        print("🫵 클릭: 회원탈퇴")
    }
    
    @objc func myPageToReport() {
        let reportVC = ReportViewController()
        reportVC.modalPresentationStyle = .fullScreen
        present(reportVC, animated: true, completion: nil)
        print("🫵 클릭: 리포트 더보기")
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
        cell.configure(settingItem)

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
            let volatilizationDateSettingAlert = UIAlertController(title: "당신의 감쓰를 며칠 후 불태워 드릴까요?", message: "", preferredStyle: .actionSheet)
            let days = ["1일", "2일", "3일", "4일", "5일", "6일", "일주일"]
            for day in days {
                let action = UIAlertAction(title: day, style: .default) { _ in
                    print("\(day) 후 감쓰를 태워 드립니다.")
                    if let indexPath = self.selectedIndexPath,
                       let cell = tableView.cellForRow(at: indexPath) as? MyPageCustomCell {
                        cell.updateDateLabel(day)
                    }
                }
                volatilizationDateSettingAlert.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            volatilizationDateSettingAlert.addAction(cancelAction)
            present(volatilizationDateSettingAlert, animated: true)
            print("🫵 클릭: 자동 휘발일 설정")
                break
            
            case .logout:
            print("🫵 클릭: 로그아웃")
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
