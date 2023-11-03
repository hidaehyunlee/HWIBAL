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
        
//        let _ = application.beginBackgroundTask(expirationHandler: {
//            // 백그라운드 태스크가 종료될 때 실행할 코드 -> 노티(푸시알림) 이벤트 발송
//            NotificationService.shared.autoDeleteNotification()
//            print("자동 휘발 노티 알림 발송")
//        })
        
        // 정기적으로 실행할 함수 호출
//        startAutoDeleteTask()
        
        return true
    }
    
//    func startAutoDeleteTask() {
//        print("""
//              📢 [자동 삭제 알림] \(String(describing: SignInService.shared.signedInUser?.autoExpireDays))일 후 삭제 예정
//              """)
//        // 백그라운드에서 실행될 함수를 호출할 타이머 설정 -> withTimeInterval: * 60 * 60 * 24 처리하면 autoExpireDays일 후 실행, repeats: true로 변경
//        // (테스트 코드) Double((SignInService.shared.signedInUser?.autoExpireDays ?? 7)) * 5, repeats: false
//        Timer.scheduledTimer(withTimeInterval: Double((SignInService.shared.signedInUser?.autoExpireDays ?? 7)) * 60 * 60 * 24, repeats: false) { _ in
//            // 원하는 주기(예: n일 간격)로 실행될 코드 작성
//            
//            print("백그라운드에서 실행 중...")
//            DispatchQueue.main.async {
//                print("삭제 로직 실행")
//                EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
//                NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
//                print("삭제 완료")
//            }
//        }
//    }

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
