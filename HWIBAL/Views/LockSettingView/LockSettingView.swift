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
        label.text = "⚠️ 암호를 분실했을 경우 앱을 삭제하고 재설치 해야하며, 재설치 시 작성한 감정쓰레기는 삭제됩니다."
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = FontGuide.size14
        label.textColor = ColorGuide.textHint
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
            make.height.equalTo(50)
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
