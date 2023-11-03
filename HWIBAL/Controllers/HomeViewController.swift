//
//  HomeViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import EventBus
import UIKit

struct PushToMyPageScreenEvent: EventProtocol {
    let payload: Void = ()
}

struct PushToCreatePageScreenEvent: EventProtocol {
    let payload: Void = ()
}

struct PushToDetailScreenEvent: EventProtocol {
    let payload: Void = ()
}

final class HomeViewController: RootViewController<HomeView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FireStoreManager.shared.getUser(userId: SignInService.shared.signedInUser!.id!, completion: <#T##FireStoreManager.UserResult##FireStoreManager.UserResult##(Result<User, Error>) -> Void#>)
        
//        FireStoreManager.shared.getDocumentCount(forCollection: "Users") { result in
//        switch result {
//        case .success(let documentCount):
//            print("Document count in the collection: \(documentCount)")
//        case .failure(let error):
//            print("Error: \(error.localizedDescription)")
//        }
//    }
        
        initializeUI()
        handleEmotionTrashUpdateNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(handleEmotionTrashUpdateNotification), name: NSNotification.Name("EmotionTrashUpdate"), object: nil)

        EventBus.shared.on(PushToMyPageScreenEvent.self, by: self) { listener, _ in
            listener.navigationController?.pushViewController(MyPageViewController(), animated: true)
        }

        EventBus.shared.on(PushToCreatePageScreenEvent.self, by: self) { listener, _ in
            let createPageVC = CreatePageViewController()
            let navigationController = UINavigationController(rootViewController: createPageVC)
            navigationController.modalPresentationStyle = .automatic
            navigationController.modalTransitionStyle = .coverVertical
            listener.present(navigationController, animated: true, completion: nil)
        }
        
        EventBus.shared.on(PushToDetailScreenEvent.self, by: self) { listener, _ in
            listener.navigationController?.pushViewController(DetailViewController(), animated: true)
        }
    }

    var hasLaunchedBefore: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if hasLaunchedBefore {
                rootView.returnHwibari()
            } else {
                hasLaunchedBefore = true
            }
    }
}

private extension HomeViewController {
    func initializeUI() {
        // MARK: - Navigation Setting

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = ColorGuide.main
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc func handleEmotionTrashUpdateNotification() {
        rootView.getEmotionTrashCount()
        DispatchQueue.main.async {
            self.rootView.updateEmotionTrashesCountLabel(self.rootView.emotionCount)
        }
    }
}
