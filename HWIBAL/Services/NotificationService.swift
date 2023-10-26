//
//  NotificationService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/24.
//

import Foundation
import UserNotifications
import UIKit

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    private let calendar = Calendar.current
    private var components = DateComponents()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func autoDeleteNotification(_ day: Int) {
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.title = "휘발이가 모든 감정쓰레기를 비웠어요!"
        content.body = "지금 눌러서 확인하기"
        content.sound = .default

        components.day = day
        if let futureDate = calendar.date(byAdding: components, to: Date()) {
            let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: futureDate)!
            let timeInterval = midnight.timeIntervalSinceNow

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 테스트 코드
            let request = UNNotificationRequest(identifier: "deleteNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification request: \(error)")
                } else {
                    print("자동 삭제 알림 등록")
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("푸시 알람 표시됨")
        DispatchQueue.main.async {
            print("삭제 로직 실행")
            EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
            NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
        }
        
        return [.list, .banner, .sound, .badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "deleteNotification" {
            
            // 알림 확인 시 뱃지 카운트 없애기
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            // 삭제
            DispatchQueue.main.async {
                print("삭제 로직 실행")
                EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
                NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
            }
            
            // HomeVC 화면 전환 코드 추가
            
        }
        completionHandler()
    }
}
