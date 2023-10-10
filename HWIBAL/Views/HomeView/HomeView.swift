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
    private lazy var label = {
        let label = UILabel()
        label.text = "Home Screen"
        label.sizeToFit()
        return label
    }()

    func initializeUI() {
        backgroundColor = .systemBackground

        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self)
        }

        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.addGestureRecognizer(tapGesture)
    }

    @objc private func labelTapped() {
        print("labelTapped")
        EventBus.shared.emit(PushToMyPageScreenEvent())
    }
}
