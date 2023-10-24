//
//  NotificationService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/24.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
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
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateComponents.day = day
        dateComponents.hour = 0
        dateComponents.minute = 0

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "deleteNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error adding notification request: \(error)")
            } else {
                print("Delete notification scheduled successfully!")
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.list, .banner, .sound, .badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "deleteNotification" {
            print("푸시 알림을 눌러야 삭제됨")
            EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
            NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
        }
        completionHandler()
    }
}
