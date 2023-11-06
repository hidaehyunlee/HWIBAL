//
//  WebViewController.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/06.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.navigationDelegate = self

        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
