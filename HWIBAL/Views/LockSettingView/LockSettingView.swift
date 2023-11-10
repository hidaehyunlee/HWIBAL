//
//  LockSettingView.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/10.
//

import UIKit

final class LockSettingView: UIView, RootView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(LockSettingCell.self, forCellReuseIdentifier: LockSettingCell.identifier)
        return tableView
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "⚠️ 암호를 분실했을 경우 암호 입력 화면에서 취소를 누르고 재로그인하시면 됩니다."
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = FontGuide.size14
        label.textColor = ColorGuide.main
        return label
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
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
