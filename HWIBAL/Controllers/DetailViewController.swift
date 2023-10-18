//
//  DetailViewController.swift
//  HWIBAL
//
//  Created by DJ S on 2023/10/17.
//

import SnapKit
import UIKit

final class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let removeView = UIView()
        removeView.backgroundColor = ColorGuide.main
        removeView.layer.cornerRadius = 4
        view.addSubview(removeView)
        
        removeView.snp.makeConstraints { make in
            make.width.equalTo(333)
            make.height.equalTo(56)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-50)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
        }
        
        let removeButton = UIButton()
        removeButton.setTitle("아, 휘발 🔥", for: .normal)
        removeButton.titleLabel?.font = FontGuide.size19Bold
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.backgroundColor = .clear
        removeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        removeView.addSubview(removeButton)
        
        removeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let returnView = UIButton()
        returnView.backgroundColor = ColorGuide.main
        returnView.layer.cornerRadius = 15
        returnView.addTarget(self, action: #selector(returnViewTapped), for: .touchUpInside)
        view.addSubview(returnView)
        
        returnView.snp.makeConstraints { make in
            make.width.equalTo(112)
            make.height.equalTo(28)
            make.top.equalTo(view).offset(115)
            make.leading.equalTo(view).offset(256)
        }
    }
    
    @objc func buttonTapped() {
        print("휘발 되었습니다.")
    }
    
    @objc func returnViewTapped() {
        print("Return 버튼이 탭되었습니다.")
    }
}
