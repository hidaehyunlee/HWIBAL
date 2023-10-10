//
//  MainViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

final class MainViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([HomeViewController()], animated: false)
    }
}
