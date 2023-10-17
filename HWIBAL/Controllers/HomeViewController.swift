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

final class HomeViewController: RootViewController<HomeView> {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()

        EventBus.shared.on(PushToMyPageScreenEvent.self, by: self) { listener, _ in
            let createPageVC = CreatePageViewController()
            let navigationController = UINavigationController(rootViewController: createPageVC)
            navigationController.modalPresentationStyle = .automatic
            navigationController.modalTransitionStyle = .coverVertical
            listener.present(navigationController, animated: true, completion: nil)
        }
    }
}

private extension HomeViewController {
    func initializeUI() {
        // MARK: - Navigation Setting

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = ColorGuide.main
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
