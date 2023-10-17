//
//  CreatePageView.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/10/12.
//
import EventBus
import UIKit

class CreatePageViewController: UIViewController {
    let createPageView = CreatePageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        view.addSubview(self.createPageView)
        self.view.backgroundColor = UIColor.white
        self.createPageView.textView.becomeFirstResponder()
    }

    func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)

        let titleColor = UIColor(red: 115/255, green: 78/255, blue: 247/255, alpha: 1)

        let leftItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(showAlert))
        leftItem.tintColor = titleColor
        self.navigationItem.leftBarButtonItem = leftItem

        let rightItem = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(showAlert))
        rightItem.tintColor = titleColor
        self.navigationItem.rightBarButtonItem = rightItem

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 41.0/34.0

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Arial-BoldMT", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold),
            .kern: 0.374,
            .paragraphStyle: paragraphStyle
        ]

        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string: "감정 쓰레기", attributes: titleAttributes)
        titleLabel.backgroundColor = .clear
        titleLabel.sizeToFit()

        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let bottomPadding: CGFloat = 15

        let titleViewHeight = self.navigationController?.navigationBar.bounds.height ?? 44.0

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleViewHeight))
        titleLabel.frame.origin = CGPoint(x: 0, y: titleViewHeight - titleLabel.frame.height - bottomPadding)
        titleView.addSubview(titleLabel)
        

        self.navigationItem.titleView = titleView

        self.navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    @objc func showAlert() {
        let alertVC = AlertViewController(title: "아,휘발", message: "정말로 삭제 하시겠습니까?")
        self.present(alertVC, animated: true, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.createPageView.frame = view.bounds
    }
}
