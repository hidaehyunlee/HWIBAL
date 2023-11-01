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
    
    private var bubbleView1Timer: Timer?
    private var bubbleView2Timer: Timer?
    
    private var isBubbleView1Visible = true
    private var isBubbleView2Visible = true
    
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
        let imageView = createImageView(named: "hwibari_default", contentMode: .scaleAspectFit)
        return imageView
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var bubbleView1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isHidden = false

        let label = UILabel()
        label.textColor = .white
        label.text = "휘발이를 누르면 작성한 감정쓰레기를 볼 수 있어요!"
        label.font = FontGuide.size14
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(10)
            make.top.bottom.equalTo(view).inset(5)
        }

        return view
    }()
    
    private lazy var bubbleView2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isHidden = false

        let label = UILabel()
        label.textColor = .white
        label.text = "아래의 좌측 버튼으로 모든 감정쓰레기를 제거하고\n 우측 버튼으로 감정쓰레기를 작성해요!"
        label.font = FontGuide.size14
        label.numberOfLines = 0
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(10)
            make.top.bottom.equalTo(view).inset(5)
        }

        return view
    }()
    
    // MARK: - Label Title Update Function
    
    func updateEmotionTrashesCountLabel(_ emotionCount: Int) {
        titleLabel2.text = "감정쓰레기 \(emotionCount)개"
    }
    
    // MARK: - Initialization
    
    func initializeUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
        myPageButton()
        setupHwibariImageView()
        setupButton()
        setupBubbleView()
        setupInfoButton()
    }
    
    // MARK: - Private Functions
    
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
            make.top.equalToSuperview().offset(90 * UIScreen.main.bounds.height / 926) // 비율 조정
            make.leading.equalToSuperview().offset(24)
        }
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalToSuperview().offset(24)
        }
        hwibariImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel2.snp.bottom).offset(100 * UIScreen.main.bounds.height / 926) // 비율 조정
            make.width.equalTo(330 * UIScreen.main.bounds.width / 428) // 너비 크게 조정
            make.height.equalTo(462 * UIScreen.main.bounds.height / 926) // 높이 크게 조정
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
    
    private func setupButton() {
        let removeBar = UIView()
        removeBar.backgroundColor = ColorGuide.main
        removeBar.layer.cornerRadius = 4
        removeBar.translatesAutoresizingMaskIntoConstraints = false
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        removeBar.addGestureRecognizer(removeTapGesture)
        
        addSubview(removeBar)
        
        let squareView = createSquareView()
        
        removeBar.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(squareView.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        let removeLabel = UILabel()
        removeLabel.textColor = .white
        removeLabel.font = FontGuide.size19Bold
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.04
        removeLabel.attributedText = NSMutableAttributedString(string: "다, 휘발 🔥", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        removeBar.addSubview(removeLabel)
        
        removeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(removeBar)
            make.centerY.equalTo(removeBar)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }
        
    private func createSquareView() -> UIView {
        let squareView = UIView()
        squareView.backgroundColor = .white
        squareView.layer.cornerRadius = 4
        squareView.layer.borderWidth = 1.5
        squareView.layer.borderColor = ColorGuide.main.cgColor
        let squareViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(createButtonTapped))
        squareView.addGestureRecognizer(squareViewTapGesture)
            
        addSubview(squareView)
            
        squareView.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }
            
        let penImage = createPenImage()
        squareView.addSubview(penImage)
            
        penImage.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.center.equalToSuperview()
        }
        return squareView
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
            hwibariImage.animationDuration = 0.3
            hwibariImage.animationRepeatCount = 1
            hwibariImage.startAnimating()
            hwibariImage.image = UIImage(named: "hwibari_default")
        }
    }
    
    private func setupBubbleView() {
        addSubview(bubbleView1)
        addSubview(bubbleView2)
        
        bubbleView1.snp.makeConstraints { make in
            make.top.equalTo(hwibariImage.snp.top).offset(5)
            make.centerX.equalToSuperview()
        }
        bubbleView2.snp.makeConstraints { make in
            make.top.equalTo(hwibariImage.snp.bottom)
            make.centerX.equalToSuperview()
        }

        let bubble1TapGesture = UITapGestureRecognizer(target: self, action: #selector(bubble1Tapped))
        bubbleView1.isUserInteractionEnabled = true
        bubbleView1.addGestureRecognizer(bubble1TapGesture)
        
        let bubble2TapGesture = UITapGestureRecognizer(target: self, action: #selector(bubble2Tapped))
        bubbleView2.isUserInteractionEnabled = true
        bubbleView2.addGestureRecognizer(bubble2TapGesture)
        
        startBubbleView1Timer()
        startBubbleView2Timer()
    }
    
    private func startBubbleView1Timer() {
        bubbleView1Timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(bubble1Tapped), userInfo: nil, repeats: false)
    }

    private func startBubbleView2Timer() {
        bubbleView2Timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(bubble2Tapped), userInfo: nil, repeats: false)
    }
    
    private func setupInfoButton() {
        addSubview(infoButton)
        
        infoButton.snp.makeConstraints { make in
            make.bottom.equalTo(hwibariImage.snp.top)
            make.centerX.equalToSuperview()
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
        hwibariImage.animationImages = [
            UIImage(named: "hwibari_ing02_fire")!,
            UIImage(named: "burningImage")!,
            UIImage(named: "hwibari_ing01_fire")!,
            UIImage(named: "hwibari_default")!
        ]
        
        hwibariImage.animationDuration = 1.0 // 애니메이션 한 번의 지속 시간을 설정
        hwibariImage.animationRepeatCount = 1 // 애니메이션의 반복 횟수를 설정
        hwibariImage.startAnimating()
        
        EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
        NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
        
        if let viewController = viewController {
            let burningView = UIView(frame: viewController.view.bounds)
            burningView.backgroundColor = UIColor(red: 247/255, green: 142/255, blue: 0/255, alpha: 1)
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
        
        hwibariImage.animationImages = [
            UIImage(named: "hwibari_default")!,
            UIImage(named: "hwibariopen")!
        ]
        hwibariImage.animationDuration = 0.3
        hwibariImage.animationRepeatCount = 1
        hwibariImage.startAnimating()
        
        hwibariImage.image = UIImage(named: "hwibariopen2")
        
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
    
    @objc private func bubble1Tapped() {
        bubbleView1.isHidden = true
        bubbleView1Timer?.invalidate()
    }
    
    @objc private func bubble2Tapped() {
        bubbleView2.isHidden = true
        bubbleView2Timer?.invalidate()
    }
    
    @objc private func infoButtonTapped() {
        bubbleView1.isHidden.toggle()
        bubbleView2.isHidden.toggle()
        
        if isBubbleView1Visible {
                startBubbleView1Timer()
            } else {
                bubbleView1Timer?.invalidate()
            }

            if isBubbleView2Visible {
                startBubbleView2Timer()
            } else {
                bubbleView2Timer?.invalidate()
            }
    }
    
    @objc private func createButtonTapped() {
        print("'작성하기'가 탭되었습니다.")
        EventBus.shared.emit(PushToCreatePageScreenEvent())
    }
}
