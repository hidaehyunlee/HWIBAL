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

    var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(createPageView)
        view.backgroundColor = UIColor.white
        createPageView.textView.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        {
            keyboardHeight = keyboardFrame.height
            adjustLayoutForKeyboardState()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
        adjustLayoutForKeyboardState()
    }

    func adjustLayoutForKeyboardState() {
        if keyboardHeight > 0 {
            let padding: CGFloat = 10
            createPageView.counterLabel.frame.origin.y = view.bounds.height - keyboardHeight - createPageView.counterLabel.frame.height - padding
            createPageView.cameraButton.frame.origin.y = createPageView.counterLabel.frame.minY - createPageView.cameraButton.frame.height - padding
            createPageView.soundButton.frame.origin.y = createPageView.cameraButton.frame.origin.y
        } else {
            createPageView.layoutSubviews()
        }
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)

        let leftItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(showCancelAlert))
        leftItem.tintColor = ColorGuide.main
        navigationItem.leftBarButtonItem = leftItem

        let rightItem = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(showWriteAlert))
        rightItem.tintColor = ColorGuide.main
        navigationItem.rightBarButtonItem = rightItem

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 41.0 / 34.0
        paragraphStyle.firstLineHeadIndent = 14.0

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .kern: 0.374,
            .paragraphStyle: paragraphStyle
        ]

        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = ColorGuide.black
        titleLabel.font = FontGuide.size32Bold
        titleLabel.sizeToFit()

        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let bottomPadding: CGFloat = 15

        let titleViewHeight = navigationController?.navigationBar.bounds.height ?? 44.0
        let titleViewWidth = navigationController?.navigationBar.bounds.width ?? UIScreen.main.bounds.width

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight))
        titleLabel.frame.origin = CGPoint(x: leftPadding, y: titleViewHeight - titleLabel.frame.height - bottomPadding)
        titleView.addSubview(titleLabel)

        navigationItem.title = "감정쓰레기"

        navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }

    @objc func showCancelAlert() {
        let alertVC = AlertViewController(title: "아, 휘발 🔥", message: "정말로 삭제 하시겠습니까?")
        present(alertVC, animated: true, completion: nil)
    }

    @objc func showWriteAlert() {
        let alertVC = AlertViewControllerDesc(title: "아, 휘발 🔥", message: "오... 그랬군요 🥹 \n당신의 감정을 3일 후에 불태워 드릴게요 🔥")
        present(alertVC, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertVC.dismiss(animated: true) {
//                EmotionTrashCount.incrementCount()
//                print("감쓰 갯수 total : ", EmotionTrashCount.totalCount)
                let homeVC = HomeViewController()
                let navigationController = UINavigationController(rootViewController: homeVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createPageView.frame = view.bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
