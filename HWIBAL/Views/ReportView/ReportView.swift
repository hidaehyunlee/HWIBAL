//
//  ReportView.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/13.
//

import UIKit
import SnapKit

final class ReportView: UIView, RootView {
    let closeButton = CloseButton(color: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .black
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(25)
            make.leading.equalToSuperview().offset(25)
        }
    }
}
