//
//  NotificationService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/24.
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func autoDeleteNotification(_ day: Int) {
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.title = "휘발이가 모든 감정쓰레기를 비웠어요!"
        content.body = "지금 눌러서 확인하기"
        content.sound = .default
        
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")
        let currentDate = Date()

        var dateComponents = DateComponents()
        dateComponents.timeZone = koreanTimeZone
        dateComponents.day = day
        dateComponents.hour = 0
        dateComponents.minute = 0

//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "deleteNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error adding notification request: \(error)")
            } else {
                print("Daily notification scheduled successfully!")
            }
        })
    }
    
}
