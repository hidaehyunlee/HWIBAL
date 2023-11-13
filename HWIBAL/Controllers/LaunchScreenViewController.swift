//
//  LaunchScreenViewController.swift
//  HWIBAL
//
//  Created by DJ S on 2023/11/09.
//

import Lottie
import UIKit

final class LaunchScreenViewController: UIViewController {
    var completion: (() -> Void)?

    init(completion: (() -> Void)?) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let animationView: LottieAnimationView = {
        print("애니메이션 확인")
        let lottieAnimationView = LottieAnimationView(name: "trash")
        lottieAnimationView.backgroundColor = .systemBackground
        return lottieAnimationView
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "아, 휘발"
        label.font = FontGuide.size28Bold
        label.textColor = ColorGuide.main
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("런치스크린 확인")

        view.backgroundColor = .systemBackground
        view.addSubview(animationView)

        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(-30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }

        animationView.backgroundColor = UIColor.systemBackground
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }

        animationView.play { _ in
            UIView.animate(withDuration: 0.7, animations: {
                self.animationView.alpha = 0
            }, completion: { _ in
                self.animationView.isHidden = true
                self.animationView.removeFromSuperview()
                self.textLabel.removeFromSuperview()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.completion?()
        }
    }
}
