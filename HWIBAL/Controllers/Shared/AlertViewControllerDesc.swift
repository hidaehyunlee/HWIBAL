//
//  AlertViewControllerDesc.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/17.
//

import UIKit

class AlertViewControllerDesc: UIViewController {
    private let alertViewDesc: AlertViewDesc

    init(title: String, message: String) {
        self.alertViewDesc = AlertViewDesc(title: title, message: message)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        dismissAfter(seconds: 2.0)
    }

    private func dismissAfter(seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func setupViews() {
        view.addSubview(alertViewDesc)

        alertViewDesc.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertViewDesc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertViewDesc.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertViewDesc.widthAnchor.constraint(equalToConstant: 273),
            alertViewDesc.heightAnchor.constraint(equalToConstant: 92)
        ])
    }
}
