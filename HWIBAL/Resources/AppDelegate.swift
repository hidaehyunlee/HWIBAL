//
//  AppDelegate.swift
//  HWIBAL
//
//  Created by daelee on 10/10/23.
//

import CoreData
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 11.0, *) {
            let notiCenter = UNUserNotificationCenter.current()
            notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, e) in }
            notiCenter.delegate = self
        } else {
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkAutoDelete), name: NSNotification.Name("UserSignIn"), object: nil)

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        checkAutoDelete()
    }
    
    @objc func checkAutoDelete() {
        print("자동 휘발일 확인")
        if let email = SignInService.shared.signedInUser?.email,
           let autoExpireDate = SignInService.shared.signedInUser?.autoExpireDate {
            let currentDate = Date()
            if currentDate >= autoExpireDate {
                EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
                print("자동 휘발 완료")
                NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
                print("감쓰 개수 업데이트 완료")

                // 다음 자동 삭제를 위해 expire date 업데이트
                let autoExpireDays = UserDefaults.standard.integer(forKey: "autoExpireDays_\(email))")
                UserService.shared.updateUser(email: email, autoExpireDays: autoExpireDays)
            } else {
                let differenceInDays = Calendar.current.dateComponents([.day], from: currentDate, to: autoExpireDate).day
                print("자동 휘발일 D-\(String(describing: differenceInDays))")
            }
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AnkiCloneApp")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.list, .banner, .sound, .badge]
    }
}
