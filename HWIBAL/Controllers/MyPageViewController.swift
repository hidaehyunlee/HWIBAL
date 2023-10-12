//
//  MyPageViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

final class MyPageViewController: RootViewController<MyPageView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

private extension MyPageViewController {
    func setup() {
        
        // MARK: - Navigation Setting
        navigationItem.title = "내 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
