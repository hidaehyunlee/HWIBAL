//
//  ImageModalViewController.swift
//  HWIBAL
//
//  Created by daelee on 11/6/23.
//

import SnapKit
import UIKit

class ImageModalViewController: RootViewController<ImageModalView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        // modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor.white

//        if let image = ImageModalView.shared.imageView.image {
//            ImageModalView.shared.imageView.image = image
//            print("image: ", image)
//            print("나 여기 있어요!")
//        }

        //NotificationCenter.default.addObserver(self, selector: #selector(handleImageNotification(_:)), name: NSNotification.Name("imageModalVC"), object: nil)

        rootView.closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }

    @objc private func handleImageNotification(_ notification: Notification) {
        if let image = notification.object as? UIImage {
            rootView.imageView.image = image
        }
    }

    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
