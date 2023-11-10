//
//  SettingView.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/08.
//

import UIKit
import SnapKit

final class SettingView: UIView, RootView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        return tableView
    }()
    
    let termsOfUse: UILabel = {
        let label = UILabel()
        label.text = "이용약관"
        label.textColor = ColorGuide.textHint
        label.font = FontGuide.size14
        label.isUserInteractionEnabled = true
        label.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        return label
    }()
    
    let seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = ColorGuide.inputLine
        view.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(12)
        }
        return view
    }()
    
    let privacyPolicy: UILabel = {
        let label = UILabel()
        label.text = "개인정보처리방침"
        label.textColor = ColorGuide.textHint
        label.font = FontGuide.size14
        label.isUserInteractionEnabled = true
        label.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        return label
    }()
    
    lazy var corpArea: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [termsOfUse, seperateLine, privacyPolicy])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .systemBackground
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(35 * UIScreen.main.bounds.height / 852)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addSubview(corpArea)
        corpArea.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
