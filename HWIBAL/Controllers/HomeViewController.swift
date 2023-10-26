//
//  HomeViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import EventBus
import UIKit

struct PushToMyPageScreenEvent: EventProtocol {
    let payload: Void = ()
}

struct PushToCreatePageScreenEvent: EventProtocol {
    let payload: Void = ()
}

struct PushToDetailScreenEvent: EventProtocol {
    let payload: Void = ()
}

final class HomeViewController: RootViewController<HomeView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEmotionTrashUpdateNotification), name: NSNotification.Name("EmotionTrashUpdate"), object: nil)

        EventBus.shared.on(PushToMyPageScreenEvent.self, by: self) { listener, _ in
            listener.navigationController?.pushViewController(MyPageViewController(), animated: true)
        }

        EventBus.shared.on(PushToCreatePageScreenEvent.self, by: self) { listener, _ in
            let createPageVC = CreatePageViewController()
            let navigationController = UINavigationController(rootViewController: createPageVC)
            navigationController.modalPresentationStyle = .automatic
            navigationController.modalTransitionStyle = .coverVertical
            listener.present(navigationController, animated: true, completion: nil)
        }
        
        EventBus.shared.on(PushToDetailScreenEvent.self, by: self) { listener, _ in
            listener.navigationController?.pushViewController(DetailViewController(), animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootView.returnHwibari() // 홈뷰 로드시 휘바리 이미지 변경
    }
}

private extension HomeViewController {
    func initializeUI() {
        // MARK: - Navigation Setting

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = ColorGuide.main
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc func handleEmotionTrashUpdateNotification() {
        rootView.emotionCount = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!).count
        DispatchQueue.main.async {
            self.rootView.updateEmotionTrashesCountLabel(self.rootView.emotionCount)
        }
    }
}
