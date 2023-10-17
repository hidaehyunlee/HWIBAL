//
//  HomeView.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//
import EventBus
import SnapKit
import UIKit

final class HomeView: UIView, RootView {

    // MARK: - Properties

    private var emotionCount = 1
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    // MARK: - UI Elements

    private lazy var titleLabel1: UILabel = {
        let label = createLabel(text: "당신의", font: .systemFont(ofSize: 32, weight: .regular))
        return label
    }()

    private lazy var titleLabel2: UILabel = {
        let label = createLabel(text: "감정쓰레기 \(emotionCount)개", font: .systemFont(ofSize: 32, weight: .bold))
        return label
    }()

    private lazy var hwibariImage: UIImageView = {
        let imageView = createImageView(named: "hwibari", contentMode: .scaleAspectFit)
        return imageView
    }()

    // MARK: - Initialization

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()

        myPageButton()
        setupHwibariImageView()
        setupRemove()
        createButton()
    }

    // MARK: - Private Functions

    private func createLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }

    private func createImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.contentMode = contentMode
        return imageView
    }

    private func addSubviews() {
        addSubview(titleLabel1)
        addSubview(titleLabel2)
        addSubview(hwibariImage)
    }

    private func setupConstraints() {
        if let safeAreaLayoutGuide = viewController?.view.safeAreaLayoutGuide {
            titleLabel1.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.left.equalTo(40)
            }
            titleLabel2.snp.makeConstraints { make in
                make.top.equalTo(titleLabel1.snp.bottom)
                make.left.equalTo(40)
            }
            hwibariImage.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel2.snp.bottom).offset(60)
            }
        }
    }

    private func myPageButton() {
        let userIconView = UIImageView(image: UIImage(named: "user"))
        userIconView.contentMode = .scaleAspectFit

        let userButton = UIBarButtonItem(customView: userIconView)
        viewController?.navigationItem.rightBarButtonItem = userButton

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myPageButtonTapped))
        userIconView.isUserInteractionEnabled = true
        userIconView.addGestureRecognizer(tapGesture)

        userIconView.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(23)
        }
    }

    private func setupHwibariImageView() {
        let hwibariTapGesture = UITapGestureRecognizer(target: self, action: #selector(hwibariImageViewTapped))
        hwibariImage.isUserInteractionEnabled = true
        hwibariImage.addGestureRecognizer(hwibariTapGesture)
    }

    private func setupRemove() {
        let coloredBar = UIView()
        coloredBar.backgroundColor = UIColor(red: 0.451, green: 0.306, blue: 0.969, alpha: 1)
        coloredBar.layer.cornerRadius = 4
        coloredBar.translatesAutoresizingMaskIntoConstraints = false
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        coloredBar.addGestureRecognizer(removeTapGesture)

        addSubview(coloredBar)

        coloredBar.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(242)
            make.leading.equalTo(self).offset(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }

        let removeButton = removeTitle()
        coloredBar.addSubview(removeButton)

        removeButton.snp.makeConstraints { make in
            make.centerX.equalTo(coloredBar)
            make.centerY.equalTo(coloredBar)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }

    private func removeTitle() -> UILabel {
        let removeButton = UILabel()
        removeButton.textColor = .white
        removeButton.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.04
        removeButton.attributedText = NSMutableAttributedString(string: "아, 휘발 🔥", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return removeButton
    }

    private func createButton() {
        let squareView = UIView()
        squareView.backgroundColor = .white
        squareView.layer.cornerRadius = 4
        squareView.layer.borderWidth = 1.5
        squareView.layer.borderColor = UIColor(red: 0.451, green: 0.306, blue: 0.969, alpha: 1).cgColor
        let squareViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(createButtonTapped))
        squareView.addGestureRecognizer(squareViewTapGesture)

        addSubview(squareView)

        squareView.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-50)
        }

        let penImage = createPenImage()
        squareView.addSubview(penImage)

        penImage.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.center.equalToSuperview()
        }
    }

    private func createPenImage() -> UIView {
        let penImage = UIView()
        penImage.translatesAutoresizingMaskIntoConstraints = false

        let image0 = UIImage(named: "pen")
        let imageView = UIImageView(image: image0)
        imageView.contentMode = .scaleAspectFit
        penImage.addSubview(imageView)

        return penImage
    }

    // MARK: - Event Handling

    @objc private func myPageButtonTapped() {
        print("'유저버튼'이 탭되었습니다.")
        EventBus.shared.emit(PushToMyPageScreenEvent())
    }

    @objc private func hwibariImageViewTapped() {
        print("'hwibari'가 탭되었습니다.")
    }

    @objc private func removeButtonTapped() {
        print("'전체지우기'가 탭되었습니다.")
        
        let alertController = AlertViewController(title: "아,휘발", message: "정말로 전체 지우시겠습니까?")

        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 삭제 관련 로직
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        viewController?.present(alertController, animated: true, completion: nil)
    }

    @objc private func createButtonTapped() {
        print("'작성하기'가 탭되었습니다.")
        EventBus.shared.emit(PushToMyPageScreenEvent())
    }
}

extension UIView {
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}
