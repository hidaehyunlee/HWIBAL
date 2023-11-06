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
    
    var emotionCount = EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!).count
    
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
        let label = UILabel()
        label.text = "당신의"
        label.textColor = .label
        label.font = FontGuide.size32
        return label
    }()
    
    private lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "감정쓰레기 \(emotionCount)개"
        label.textColor = .label
        label.font = FontGuide.size32Bold
        return label
    }()
    
    private lazy var hwibariImage: UIImageView = {
        let imageView = hwibariImageView(named: "hwibari_default", contentMode: .scaleAspectFit)
        return imageView
    }()
    
    private lazy var tooltipView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
    }()

    private lazy var hwibariImageTooltipView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "guideimage")
        imageView.contentMode = .scaleToFill
        imageView.isHidden = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var hideTooltipButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(hideTooltipButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var myPageButton: UIBarButtonItem = {
        let userIconView = UIImageView(image: UIImage(named: "user"))
        userIconView.contentMode = .scaleAspectFit
        
        let userButton = UIBarButtonItem(customView: userIconView)
        userButton.target = self
        userButton.action = #selector(myPageButtonTapped)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myPageButtonTapped))
        userIconView.isUserInteractionEnabled = true
        userIconView.addGestureRecognizer(tapGesture)
        
        userIconView.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(23)
        }
        
        return userButton
    }()

    // MARK: - Label Title Update Function
    
    func updateEmotionTrashesCountLabel(_ emotionCount: Int) {
        titleLabel2.text = "감정쓰레기 \(emotionCount)개"
    }
    
    // MARK: - Initialization
    
    func initializeUI() {
        backgroundColor = .systemBackground
        myPageButton.isEnabled = false
        myPageButton.customView?.alpha = 0.2
        addSubviews()
        setupConstraints()
        setupHwibariImageView()
        setupButton()
        setupTooltipView()
    }
    
    // MARK: - Private Functions
    
    private func hwibariImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.contentMode = contentMode
        return imageView
    }
    
    private func addSubviews() {
        addSubview(titleLabel1)
        addSubview(titleLabel2)
        addSubview(hwibariImage)
        viewController?.navigationItem.rightBarButtonItem = myPageButton
    }
    
    private func setupConstraints() {
        titleLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90 * UIScreen.main.bounds.height / 852) // 비율 조정
            make.leading.equalToSuperview().offset(24)
        }
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalToSuperview().offset(24)
        }
        hwibariImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel2.snp.bottom).offset(59 * UIScreen.main.bounds.height / 852) // 비율 조정
            make.width.equalTo(289 * UIScreen.main.bounds.width / 393) // 너비 조정
            make.height.equalTo(407 * UIScreen.main.bounds.height / 852) // 높이 조정
        }
        myPageButton.customView?.snp.makeConstraints { make in
                make.width.equalTo(23)
                make.height.equalTo(23)
            }
    }
    
    private func setupHwibariImageView() {
        let hwibariTapGesture = UITapGestureRecognizer(target: self, action: #selector(hwibariImageViewTapped))
        hwibariImage.isUserInteractionEnabled = true
        hwibariImage.addGestureRecognizer(hwibariTapGesture)
    }
    
    private func setupButton() {
        let deleteButton = UIView()
        deleteButton.backgroundColor = ColorGuide.main
        deleteButton.layer.cornerRadius = 4
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        deleteButton.addGestureRecognizer(removeTapGesture)
        
        addSubview(deleteButton)
        
        let pencilView = pencilImageView()
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(pencilView.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        let removeLabel = UILabel()
        removeLabel.textColor = .white
        removeLabel.font = FontGuide.size19Bold
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.04
        removeLabel.attributedText = NSMutableAttributedString(string: "다, 휘발 🔥", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        deleteButton.addSubview(removeLabel)
        
        removeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(deleteButton)
            make.centerY.equalTo(deleteButton)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }
        
    private func pencilImageView() -> UIView {
        let writeButton = UIView()
        writeButton.backgroundColor = .white
        writeButton.layer.cornerRadius = 4
        writeButton.layer.borderWidth = 1.5
        writeButton.layer.borderColor = ColorGuide.main.cgColor
        let pencilImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(createButtonTapped))
        writeButton.addGestureRecognizer(pencilImageViewTapGesture)
            
        addSubview(writeButton)
            
        writeButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }
            
        let penImage = createPenImage()
        writeButton.addSubview(penImage)
            
        penImage.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.center.equalToSuperview()
        }
        return writeButton
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
                UIImage(named: "hwibariopen")!
            ]
        } else {
            hwibariImage.animationImages = [
                UIImage(named: "hwibariopen01")!,
                UIImage(named: "hwibariopen02")!
            ]
        }
    
        hwibariImage.animationDuration = 0.3
        hwibariImage.animationRepeatCount = 1
        hwibariImage.startAnimating()
        hwibariImage.image = UIImage(named: "hwibari_default")
    }
    
    private func setupTooltipView() {

        addSubview(tooltipView)
        tooltipView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tooltipView.addSubview(hwibariImageTooltipView)
        
        hwibariImageTooltipView.layer.cornerRadius = 12
        hwibariImageTooltipView.layer.masksToBounds = true

        hwibariImageTooltipView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(340)
        }
        
        tooltipView.addSubview(hideTooltipButton)
            
        hideTooltipButton.snp.makeConstraints { make in
            make.top.equalTo(hwibariImageTooltipView.snp.top).offset(15)
            make.trailing.equalTo(hwibariImageTooltipView.snp.trailing).offset(-15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }

    // 애니메이션을 시작하는 함수
    private func startRemoveAnimation() {
        print("다태웠어요")
        
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        shakeAnimation.values = [-0.1, 0.1, -0.1, 0.1, 0] // 왼쪽-오른쪽 흔들림
        shakeAnimation.duration = 0.5
        shakeAnimation.repeatCount = 2 // 몇 번 반복할 지 설정 (짝수로 설정하면 초기 위치로 돌아옴)
        hwibariImage.layer.add(shakeAnimation, forKey: "shake")
        
        UIView.transition(with: hwibariImage, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: { _ in
            self.continueRemoveAnimation()
        })
    }
    
    // 추가 애니메이션을 시작하는 함수
    private func continueRemoveAnimation() {
        if emotionCount == 0 {
            hwibariImage.animationImages = [
                UIImage(named: "hwibari_ing01_fire")!,
                UIImage(named: "burningImage")!,
                UIImage(named: "hwibari_ing01_fire")!,
                UIImage(named: "hwibari_default")!
            ]
        } else {
            hwibariImage.animationImages = [
                UIImage(named: "hwibari_ing02_fire")!,
                UIImage(named: "burningImage")!,
                UIImage(named: "hwibari_ing01_fire")!,
                UIImage(named: "hwibari_default")!
            ]
        }
        
        hwibariImage.animationDuration = 1.0 // 애니메이션 한 번의 지속 시간을 설정
        hwibariImage.animationRepeatCount = 1 // 애니메이션의 반복 횟수를 설정
        hwibariImage.startAnimating()
        
        EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
        NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
        
        if let viewController = viewController {
            let burningView = UIView(frame: viewController.view.bounds)
            burningView.backgroundColor = UIColor(red: 247 / 255, green: 142 / 255, blue: 0 / 255, alpha: 1)
            burningView.alpha = 0.9 // 그라디언트 효과의 불투명도 설정
            viewController.view.addSubview(burningView)
            
            // 그라디언트 마스크 레이어를 생성
            let maskLayer = CAGradientLayer()
            maskLayer.frame = viewController.view.bounds
            maskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
            maskLayer.locations = [0, 1.5, 3.0] // 그라디언트 위치 설정
            burningView.layer.mask = maskLayer
            
            // 불타는 애니메이션
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [0.75, 1, 1.5] // 아래에서 위로 이동하도록
            animation.toValue = [0, 0, 0.2] // 0~1, 낮을수록 채색 선명
            // 그라디언트 위치가 어두운 부분으로 이동하도록 끝 위치를 나타냅니다
            // maskLayer.colors에서 clear = 0, clear = 0, black = 0.2
            animation.duration = 0.8
            maskLayer.add(animation, forKey: "burningAnimation")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                burningView.removeFromSuperview()
            }
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
        
        if emotionCount == 0 {
            hwibariImage.animationImages = [
                UIImage(named: "hwibari_default")!,
                UIImage(named: "hwibariopen02")!
            ]
        } else {
            hwibariImage.animationImages = [
                UIImage(named: "hwibari_default")!,
                UIImage(named: "hwibariopen")!
            ]
        }
        hwibariImage.animationDuration = 0.3
        hwibariImage.animationRepeatCount = 1
        hwibariImage.startAnimating()
            
        if emotionCount == 0 {
            hwibariImage.image = UIImage(named: "hwibariopen01")
        } else {
            hwibariImage.image = UIImage(named: "hwibariopen2")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let detailViewController = DetailViewController()
            if let navigationController = self.viewController?.navigationController {
                navigationController.pushViewController(detailViewController, animated: true)
            }
            self.isHwibariImageTapped = false
        }
    }
    
    @objc private func removeButtonTapped() {
        print("'전체지우기'가 탭되었습니다.")
        
        // AlertManager를 사용하여 확인 다이얼로그를 표시
        AlertManager.shared.showAlert(on: viewController!,
                                      title: "다, 휘발 🔥",
                                      message: "정말로 전체 지우시겠습니까?",
                                      okCompletion: { _ in
                                          self.startRemoveAnimation()
                                      })
    }
    
    @objc private func hideTooltipButtonTapped() {
        tooltipView.isHidden = true
        myPageButton.isEnabled = true
        myPageButton.customView?.alpha = 1.0
    }

    @objc private func createButtonTapped() {
        print("'작성하기'가 탭되었습니다.")
        EventBus.shared.emit(PushToCreatePageScreenEvent())
    }
}
