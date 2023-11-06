//
//  RootViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import UIKit

class RootViewController<View: RootView>: UIViewController {
    var rootView: View { view as! View }

    override func loadView() {
        view = View()
        rootView.viewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.initializeUI()
        hideKeyboard()
    }

    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RootViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
