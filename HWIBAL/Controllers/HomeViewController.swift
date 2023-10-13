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

        EventBus.shared.on(PushToMyPageScreenEvent.self, by: self) { listener, _ in
            let createPageVC = CreatePageViewController()
            let navigationController = UINavigationController(rootViewController: createPageVC)
            listener.present(navigationController, animated: true, completion: nil)
        }
    }
}






