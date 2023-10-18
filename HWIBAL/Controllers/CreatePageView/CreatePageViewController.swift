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

        let leftItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.showCancelAlert))
        leftItem.tintColor = ColorGuide.main
        self.navigationItem.leftBarButtonItem = leftItem

        let rightItem = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(self.showWriteAlert))
        rightItem.tintColor = ColorGuide.main
        self.navigationItem.rightBarButtonItem = rightItem

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 41.0 / 34.0
        paragraphStyle.firstLineHeadIndent = 14.0 

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .kern: 0.374,
            .paragraphStyle: paragraphStyle
        ]

        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string: "감정쓰레기", attributes: titleAttributes)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = ColorGuide.black
        titleLabel.font = FontGuide.size32Bold
        titleLabel.sizeToFit()

        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let bottomPadding: CGFloat = 15

        let titleViewHeight = self.navigationController?.navigationBar.bounds.height ?? 44.0
        let titleViewWidth = self.navigationController?.navigationBar.bounds.width ?? UIScreen.main.bounds.width

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight))
        titleLabel.frame.origin = CGPoint(x: leftPadding, y: titleViewHeight - titleLabel.frame.height - bottomPadding)
        titleView.addSubview(titleLabel)

        self.navigationItem.title = "감정쓰레기"

        self.navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }

    @objc func showCancelAlert() {
        let alertVC = AlertViewController(title: "아, 휘발 🔥", message: "정말로 삭제 하시겠습니까?")
        self.present(alertVC, animated: true, completion: nil)
    }

    @objc func showWriteAlert() {
        let alertVC = AlertViewControllerDesc(title: "아, 휘발 🔥", message: "오... 그랬군요 🥹 \n당신의 감정을 3일 후에 불태워 드릴게요 🔥")
        self.present(alertVC, animated: true, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.createPageView.frame = view.bounds
    }
}
