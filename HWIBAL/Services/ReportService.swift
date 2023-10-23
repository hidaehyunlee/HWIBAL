//
//  ReportService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/18.
//

import Foundation

class ReportService {
    static let shared = ReportService()
    
    private func convertToKoreanTime(_ date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let koreanDateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: koreanDateString)
    }

    // 유저의 감정쓰레기 개수
    func calculateEmotionTrashCount() -> Int {
        return EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!).count
    }

    // 모든 유저의 감정쓰레기 개수 평균
    func calculateAverageEmotionTrashCount() -> Int {
        let totalTrashCount = EmotionTrashService.shared.fetchAllEmotionTrashes().count
        let totalUserCount = UserService.shared.fetchAllUsers().count

        return totalTrashCount / totalUserCount
    }

    // 로그인 유저와 모든 유저의 감정쓰레기 개수 비교
    func calculateComparison() -> Int {
        let emotionTrashCount = calculateEmotionTrashCount()
        let averageTrashCount = calculateAverageEmotionTrashCount()

        return emotionTrashCount - averageTrashCount
    }

    func calculateDaysOfWeekCount() -> [String: Int] {
        var daysOfWeekCount: [String: Int] = [:]

        for emotionTrash in EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!) {
            if let koreanDate = convertToKoreanTime(emotionTrash.timestamp ?? Date()) {
                let dayOfWeek = Calendar.current.component(.weekday, from: koreanDate)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                let dayOfWeekString = dateFormatter.shortWeekdaySymbols[dayOfWeek - 1]
                
                daysOfWeekCount[dayOfWeekString, default: 0] += 1
            }
        }

        return daysOfWeekCount
    }

    func calculateTimeZoneCount() -> [String: Int] {
        var timeZoneCount: [String: Int] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        for emotionTrash in EmotionTrashService.shared.fetchTotalEmotionTrashes(SignInService.shared.signedInUser!) {
            if let koreanDate = convertToKoreanTime(emotionTrash.timestamp ?? Date()) {
                let hour = Int(dateFormatter.string(from: koreanDate)) ?? 0

                switch hour {
                case 8..<11:
                    timeZoneCount["8To11", default: 0] += 1
                case 11..<15:
                    timeZoneCount["11To15", default: 0] += 1
                case 15..<19:
                    timeZoneCount["15To19", default: 0] += 1
                case 19..<22:
                    timeZoneCount["19To22", default: 0] += 1
                case 22..<24, 0..<2:
                    timeZoneCount["22To2", default: 0] += 1
                case 2..<8:
                    timeZoneCount["2To8", default: 0] += 1
                default:
                    break
                }
            }
        }

        return timeZoneCount
    }
    
}
