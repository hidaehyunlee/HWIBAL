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
    
    var emotionCount = 0
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        getEmotionTrashCount()
        initializeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getEmotionTrashCount()
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
        let imageView = createImageView(named: "hwibari_default", contentMode: .scaleAspectFit)
        return imageView
    }()
    
    // MARK: - Label Title Update Function
    
    func updateEmotionTrashesCountLabel(_ emotionCount: Int) {
        titleLabel2.text = "감정쓰레기 \(emotionCount)개"
    }
    
    func getEmotionTrashCount() {
        if let userId = FireStoreManager.shared.signInUser?.id {
            FireStoreManager.shared.getEmotionTrashCount(userId: userId) { result in
                switch result {
                case .success(let documentCount):
                    self.emotionCount = documentCount
                case .failure(let error):
                    print("Error fetching emotion trash documents: \(error)")
                }
            }
        } else {
            // userId가 nil인 경우에 대한 처리
        }
        
    }
    
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
        let removeBar = UIView()
        removeBar.backgroundColor = ColorGuide.main
        removeBar.layer.cornerRadius = 4
        removeBar.translatesAutoresizingMaskIntoConstraints = false
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        removeBar.addGestureRecognizer(removeTapGesture)
        
        addSubview(removeBar)
        
        removeBar.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(279)
            make.leading.equalTo(self).offset(24)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        let removeButton = removeTitle()
        removeBar.addSubview(removeButton)
        
        removeButton.snp.makeConstraints { make in
            make.centerX.equalTo(removeBar)
            make.centerY.equalTo(removeBar)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }
    
    private func removeTitle() -> UILabel {
        let removeButton = UILabel()
        removeButton.textColor = .white
        removeButton.font = FontGuide.size19Bold
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
        squareView.layer.borderColor = ColorGuide.main.cgColor
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
                UIImage(named: "hwibariopen")!
            ]
            hwibariImage.animationDuration = 0.3
            hwibariImage.animationRepeatCount = 1
            hwibariImage.startAnimating()
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
        
//        EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
//        FireStoreManager.shared.deleteAllEmotionTrash { error in
//            if let error = error {
//                print("Error deleting documents: \(error.localizedDescription)")
//            } else {
//                print("All documents deleted successfully.")
//            }
//        }
        
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
            animation.toValue = [0, 0, 0.2]
            // 그라디언트 위치가 어두운 부분으로 이동하도록 끝 위치를 나타냅니다
            // maskLayer.colors에서 clear = 0, clear = 0, black = 0.2
            animation.duration = 0.8
            maskLayer.add(animation, forKey: "burningAnimation")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                burningView.removeFromSuperview()
            }
        }
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
