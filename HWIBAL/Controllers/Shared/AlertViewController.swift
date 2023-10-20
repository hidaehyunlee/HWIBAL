//
//  AlertViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

//
//  AlertViewController.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/13.
//

import UIKit

class AlertViewController: UIViewController {
    private let alertView: AlertView
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    init(title: String, message: String) {
        self.alertView = AlertView(title: title, message: message)
        super.init(nibName: nil, bundle: nil)

        setupAlertActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(alertView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAlertActions() {
        alertView.cancelAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        alertView.confirmAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
