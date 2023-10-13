//
//  ReportViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit

final class ReportViewController: UIViewController {
    private let reportView = ReportView()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
}

private extension ReportViewController {
    func initializeUI() {
        view = reportView
        reportView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
}
