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

    private lazy var hwibariImageTooltipView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.9)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isHidden = false

        let label = UILabel()
        label.textColor = .white
        label.text = "휘발이를 누르면 작성한 감정쓰레기를 볼 수 있어요!\n하부에는 두개의 버튼이 있어요!\n좌측버튼은 모든 감정쓰레기를 제거해요!\n우측버튼은 감정쓰레기를 작성할 수 있어요!"
        label.font = FontGuide.size16Bold
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle() // 생성시 텍스트의 스타일 및 서식을 정의 가능
        paragraphStyle.lineSpacing = 8 // 줄간격 값 설정

        let attributedText = NSMutableAttributedString(string: label.text ?? "")
        // label.text에서 텍스트를 가져와 이 텍스트를 가지고 있는 attributedText를 생성
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        // NSAttributedString.Key.paragraphStyle 속성을 적용
        
        label.attributedText = attributedText // 줄간격이 적용된 텍스트가 라벨에 표시
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }

        return view
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return tapGesture
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
        setuphwibariImageTooltipView()
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Private Functions
    
    private func hwibariImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
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
            make.top.equalTo(titleLabel2.snp.bottom).offset(80 * UIScreen.main.bounds.height / 926) // 비율 조정
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
        let deleteButton = UIView()
        deleteButton.backgroundColor = ColorGuide.main
        deleteButton.layer.cornerRadius = 4
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        deleteButton.addGestureRecognizer(removeTapGesture)
        
        addSubview(deleteButton)
        
        let squareView = createSquareView()
        
        deleteButton.snp.makeConstraints { make in
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
        
        deleteButton.addSubview(removeLabel)
        
        removeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(deleteButton)
            make.centerY.equalTo(deleteButton)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }
        
    private func createSquareView() -> UIView {
        let writeButton = UIView()
        writeButton.backgroundColor = .white
        writeButton.layer.cornerRadius = 4
        writeButton.layer.borderWidth = 1.5
        writeButton.layer.borderColor = ColorGuide.main.cgColor
        let squareViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(createButtonTapped))
        writeButton.addGestureRecognizer(squareViewTapGesture)
            
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
    
    private func setuphwibariImageTooltipView() {
        addSubview(hwibariImageTooltipView)
        
        hwibariImageTooltipView.snp.makeConstraints { make in
            make.top.equalTo(hwibariImage.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(120)
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
    
    private func hideTooltip() {
        hwibariImageTooltipView.isHidden = true
    }
    
    // MARK: - Event Handling
    
    @objc private func myPageButtonTapped() {
        print("'유저버튼'이 탭되었습니다.")
        
        hideTooltip()
        
        EventBus.shared.emit(PushToMyPageScreenEvent())
    }
    
    @objc private func hwibariImageViewTapped() {
        if isHwibariImageTapped {
            return
        }
        isHwibariImageTapped = true // hwibariImageViewTapped 중복실행 방지 (True/false)
        
        print("'hwibari'가 탭되었습니다.")
        
        hideTooltip()
        
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
        
        hideTooltip()
        
        // AlertManager를 사용하여 확인 다이얼로그를 표시
        AlertManager.shared.showAlert(on: viewController!,
                                      title: "다, 휘발 🔥",
                                      message: "정말로 전체 지우시겠습니까?",
                                      okCompletion: { _ in
                                          self.startRemoveAnimation()
                                      })
    }

    @objc private func createButtonTapped() {
        print("'작성하기'가 탭되었습니다.")
        
        hideTooltip()
        
        EventBus.shared.emit(PushToCreatePageScreenEvent())
    }
    
    @objc private func handleTap() {
        hideTooltip()
    }
}
