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

    private var isHwibariImageTapped = false
    
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
        let imageView = createImageView(named: "hwibari_default", contentMode: .scaleAspectFit)
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
        imageView.snp.makeConstraints { make in
            make.width.equalTo(289)
            make.height.equalTo(407)
        }
        return imageView
    }
    
    private func addSubviews() {
        addSubview(titleLabel1)
        addSubview(titleLabel2)
        addSubview(hwibariImage)
    }
    
    private func setupConstraints() {
        titleLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(107)
            make.left.equalTo(24)
        }
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.left.equalTo(24)
        }
        hwibariImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel2.snp.bottom).offset(60)
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
        coloredBar.backgroundColor = ColorGuide.main
        coloredBar.layer.cornerRadius = 4
        coloredBar.translatesAutoresizingMaskIntoConstraints = false
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        coloredBar.addGestureRecognizer(removeTapGesture)
        
        addSubview(coloredBar)
        
        coloredBar.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(279)
            make.leading.equalTo(self).offset(24)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-40)
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
        removeButton.attributedText = NSMutableAttributedString(string: "다, 휘발 🔥", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-40)
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
    
    func returnHwibari() {
        if hwibariImage.image == UIImage(named: "hwibariopen2") {
            hwibariImage.animationImages = [
                UIImage(named: "hwibariopen2")!,
                UIImage(named: "hwibariopen")!,
                UIImage(named: "hwibari_default")!
            ]
            hwibariImage.animationDuration = 0.3
            hwibariImage.animationRepeatCount = 1
            hwibariImage.startAnimating()
            hwibariImage.image = UIImage(named: "hwibari_default")
        } else if hwibariImage.image == UIImage(named: "burningImage") {
            hwibariImage.image = UIImage(named: "hwibari_default")
        }
    }

    // MARK: - Event Handling
    
    @objc private func myPageButtonTapped() {
        print("'유저버튼'이 탭되었습니다.")
        EventBus.shared.emit(PushToMyPageScreenEvent())
    }
    
    @objc private func hwibariImageViewTapped() {
        if isHwibariImageTapped {
            return
        }
        isHwibariImageTapped = true // hwibariImageViewTapped 중복실행 방지 (True/false)
        
        print("'hwibari'가 탭되었습니다.")
        
        hwibariImage.animationImages = [
            UIImage(named: "hwibari_default")!,
            UIImage(named: "hwibariopen")!,
            UIImage(named: "hwibariopen2")!,
        ]
        hwibariImage.animationDuration = 0.3
        hwibariImage.animationRepeatCount = 1
        hwibariImage.startAnimating()
        
        hwibariImage.image = UIImage(named: "hwibariopen2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let detailViewController = DetailViewController()
            if let navigationController = self.viewController?.navigationController {
                navigationController.pushViewController(detailViewController, animated: true)
            }
            self.isHwibariImageTapped = false
        }
    }
    
    @objc private func removeButtonTapped() {
        print("'전체지우기'가 탭되었습니다.")
        
        let alertController = UIAlertController(title: "아, 휘발 🔥", message: "정말로 전체 지우시겠습니까?", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            if let self = self {
                        self.hwibariImage.image = UIImage(named: "burningImage")
                        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
                        shakeAnimation.values = [-0.1, 0.1, -0.1, 0.1, 0] // 각 프레임별 회전 값 (왼쪽-오른쪽 흔들림)
                        shakeAnimation.duration = 0.5
                        shakeAnimation.repeatCount = 2 // 몇 번 반복할 지 설정 (짝수로 설정하면 초기 위치로 돌아옴)
                        self.hwibariImage.layer.add(shakeAnimation, forKey: "shake")
                        UIView.transition(with: self.hwibariImage, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    }

            if let viewController = self?.viewController {
                let burningLayer = CALayer()
                burningLayer.backgroundColor = ColorGuide.main.cgColor
                burningLayer.frame = viewController.view.bounds
                viewController.view.layer.addSublayer(burningLayer)

                let burnAnimation = CABasicAnimation(keyPath: "opacity")
                burnAnimation.fromValue = 1.0 // 시작 채도
                burnAnimation.toValue = 0.0 // 종료 채도
                burnAnimation.duration = 0.5
                burningLayer.add(burnAnimation, forKey: "burnAnimation")

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    burningLayer.removeFromSuperlayer()
                }
            }
            print("다태웠어요")
        }
        
//        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
//            if let self = self {
//                        self.hwibariImage.image = UIImage(named: "burningImage")
//                let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
//                shakeAnimation.values = [-0.1, 0.1, -0.1, 0.1, 0] // 각 프레임별 회전 값 (왼쪽-오른쪽 흔들림)
//                shakeAnimation.duration = 0.5
//                shakeAnimation.repeatCount = 2 // 몇 번 반복할 지 설정 (짝수로 설정하면 초기 위치로 돌아옴)
//                self.hwibariImage.layer.add(shakeAnimation, forKey: "shake")
//                        UIView.transition(with: self.hwibariImage, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//                    }
//
//                if let viewController = self?.viewController {
//                    let burningView = UIView(frame: viewController.view.bounds)
//                    burningView.backgroundColor = ColorGuide.main
//                    burningView.alpha = 0.7 // 불투명도를 0.7로 설정
//                    viewController.view.addSubview(burningView)
//
//                    // 그라디언트 마스크 레이어를 생성
//                    let maskLayer = CAGradientLayer()
//                    maskLayer.frame = viewController.view.bounds
//                    maskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
//                    maskLayer.locations = [0, 1.5, 3.0] // 그라디언트 위치 설정
//                    burningView.layer.mask = maskLayer
//
//                    // 불타는 애니메이션
//                    let animation = CABasicAnimation(keyPath: "locations")
//                    animation.fromValue = [0.75, 1, 1.5] // 아래에서 위로 이동하도록
//                    animation.toValue = [0, 0, 0.2] // 그라디언트 위치의 끝 값
//                    animation.duration = 0.7
//                    maskLayer.add(animation, forKey: "burningAnimation")
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                        burningView.removeFromSuperview()
//                    }
//                }
//                print("다태웠어요")
//            }

//        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
//            if let self = self {
//                        self.hwibariImage.image = UIImage(named: "burningImage")
//                let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
//                shakeAnimation.values = [-0.1, 0.1, -0.1, 0.1, 0] // 각 프레임별 회전 값 (왼쪽-오른쪽 흔들림)
//                shakeAnimation.duration = 0.5
//                shakeAnimation.repeatCount = 2 // 몇 번 반복할 지 설정 (짝수로 설정하면 초기 위치로 돌아옴)
//                self.hwibariImage.layer.add(shakeAnimation, forKey: "shake")
//                UIView.transition(with: self.hwibariImage, duration: 1.0, options: .transitionCrossDissolve, animations: nil, completion: nil)
//                    }
//
//                if let viewController = self?.viewController {
//                    let burstContainerView = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: viewController.view.bounds.height))
//                    burstContainerView.backgroundColor = UIColor.clear
//                    viewController.view.addSubview(burstContainerView)
//
//                    for _ in 0..<20 {
//                        let burstView = UIView(frame: CGRect(x: viewController.view.center.x, y: viewController.view.center.y, width: 100, height: 100))
//                        burstView.backgroundColor = ColorGuide.main
//                        burstView.layer.cornerRadius = burstView.frame.width / 2.0
//                        burstContainerView.addSubview(burstView)
//
//                        // 각 원마다 랜덤한 크기와 속도로 터지는 애니메이션 적용
//                        let randomScale = CGFloat(arc4random_uniform(16) + 3) // 크기 범위를 3에서 16 사이로 조절
//                        let randomSpeed = Double(arc4random_uniform(1) + 1) // 속도 범위
//                        UIView.animate(withDuration: randomSpeed, delay: 0, options: .curveEaseOut, animations: {
//                            burstView.transform = CGAffineTransform(scaleX: randomScale, y: randomScale)
//                            burstView.alpha = 0
//                        }, completion: { _ in
//                            burstView.removeFromSuperview()
//                        })
//                    }
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        burstContainerView.removeFromSuperview()
//                                    }
//                }
//                print("다터졌어요")
//            }
        
//        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
//            if let self = self {
//                    self.hwibariImage.image = UIImage(named: "burningImage")
//                let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
//                shakeAnimation.values = [-0.1, 0.1, -0.1, 0.1, 0] // 각 프레임별 회전 값 (왼쪽-오른쪽 흔들림)
//                shakeAnimation.duration = 0.5
//                shakeAnimation.repeatCount = 2 // 몇 번 반복할 지 설정 (짝수로 설정하면 초기 위치로 돌아옴)
//                self.hwibariImage.layer.add(shakeAnimation, forKey: "shake")
//                UIView.transition(with: self.hwibariImage, duration: 1.0, options: .transitionCrossDissolve, animations: nil, completion: nil)
//                    startBurstAnimation()
//                }
//            }
//        func startBurstAnimation() {
//            if let viewController = self.viewController {
//                let burstContainerView = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: viewController.view.bounds.height))
//                burstContainerView.backgroundColor = UIColor.clear
//                viewController.view.addSubview(burstContainerView)
//
//                for _ in 0..<20 { // 원의 개수를 변경할 수 있음
//                    // 원의 위치를 무작위로 설정
//                    let randomX = CGFloat(arc4random_uniform(UInt32(viewController.view.bounds.width)))
//                    let randomY = CGFloat(arc4random_uniform(UInt32(viewController.view.bounds.height)))
//
//                    // 터지는 원을 생성하고 설정
//                    let burstView = UIView(frame: CGRect(x: randomX, y: randomY, width: 60, height: 60))
//                    burstView.backgroundColor = ColorGuide.main
//                    burstView.layer.cornerRadius = burstView.frame.width / 2.0
//                    burstContainerView.addSubview(burstView)
//
//                    // 각 원마다 랜덤한 크기와 속도로 터지는 애니메이션 적용
//                    let randomScale = CGFloat(arc4random_uniform(16) + 3) // 크기 범위를 3에서 16 사이로 조절
//                    let randomSpeed = Double(arc4random_uniform(2) + 1) // 속도 범위
//                    UIView.animate(withDuration: randomSpeed, delay: 0, options: .curveEaseOut, animations: {
//                        burstView.transform = CGAffineTransform(scaleX: randomScale, y: randomScale) // 원을 확대
//                        burstView.alpha = 0 // 투명하게 만들어서 사라지도록
//                    }, completion: { _ in
//                        burstView.removeFromSuperview() // 애니메이션이 완료되면 원 제거
//                    })
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    burstContainerView.removeFromSuperview()
//                }
//            }
//            print("다터졌어요")
//        }

        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        print("'작성하기'가 탭되었습니다.")
        EventBus.shared.emit(PushToCreatePageScreenEvent())
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
