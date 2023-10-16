//
//  AlertViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

import UIKit

class AlertViewController: UIViewController {
    private let alertView: AlertView

    init(title: String, message: String) {
        self.alertView = AlertView(title: title, message: message)
        super.init(nibName: nil, bundle: nil)

        alertView.buttonAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        view.addSubview(alertView)

        // alertView의 레이아웃 설정
        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 273),
            alertView.heightAnchor.constraint(greaterThanOrEqualToConstant: 92)
        ])
    }
}
