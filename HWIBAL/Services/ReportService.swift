//
//  ReportService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/18.
//

import CoreData
import Foundation

class ReportService {
    static let shared = ReportService()
    let coreDataManager = CoreDataManager.shared
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    // print: 유저의 전체 리포트 출력
    func printTotalReports(_ user: User) {
        let reports = fetchTotalEmotionTrashes(user)
        for report in reports {
            print("reports -")
            print("""
            text: \(report.text ?? "")
            timestamp: \(report.timestamp ?? Date())
            """)
        }
    }

    // fetch: 유저의 전체 감정쓰레기 가져오기
    func fetchTotalEmotionTrashes(_ user: User) -> [Report] {
        let fetchRequest: NSFetchRequest<Report> = Report.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching emotionTrashes: \(error)")
            return []
        }
    }

    // fetch: 모든 유저의 전체 감정쓰레기 가져오기
    func fetchAllUsersEmotionTrashes() -> [Report] {
        let fetchRequest: NSFetchRequest<Report> = Report.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching emotionTrashes: \(error)")
            return []
        }
    }

    // delete: 모든 유저의 감정쓰레기 전체 삭제
    func deleteAllUsersEmotionTrash() {
        let fetchRequest: NSFetchRequest<Report> = Report.fetchRequest()

        do {
            let emotionTrashes = try context.fetch(fetchRequest)
            for emotionTrash in emotionTrashes {
                context.delete(emotionTrash)
            }
            coreDataManager.saveContext()
        } catch {
            print("Error deleting all emotionTrashes: \(error)")
        }
    }

    private func convertToKoreanTime(_ date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let koreanDateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: koreanDateString)
    }

    // 유저의 감정쓰레기 개수
    func calculateEmotionTrashCount() -> Int {
        return fetchTotalEmotionTrashes(SignInService.shared.signedInUser!).count
    }

    // 모든 유저의 감정쓰레기 개수 평균
    func calculateAverageEmotionTrashCount() -> Int {
        let totalTrashCount = fetchAllUsersEmotionTrashes().count
        let totalUserCount = UserService.shared.fetchAllUsers().count

        return totalTrashCount / totalUserCount
    }

    // 로그인 유저와 모든 유저의 감정쓰레기 개수 비교
    func calculateComparison() -> Int {
        let emotionTrashCount = calculateEmotionTrashCount()
        let averageTrashCount = calculateAverageEmotionTrashCount()

        return emotionTrashCount - averageTrashCount
    }

    // 날짜에 따른 감정쓰레기 개수 가져오기
    func fetchEmotionTrashCount(user: User, startDate: Date, endDate: Date) -> Int {
        let fetchRequest: NSFetchRequest<Report> = Report.fetchRequest()
        
        // NSDate로 변환
        let nsStartDate = startDate as NSDate
        let nsEndDate = endDate as NSDate
        
        // "createdAt" 속성을 사용하여 날짜 범위로 필터링
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND timestamp >= %@ AND timestamp < %@", argumentArray: [user, nsStartDate, nsEndDate])

        do {
            let reports = try context.fetch(fetchRequest)
            return reports.count
        } catch {
            print("Error fetching emotion trash: \(error)")
            return 0
        }
    }

    // 이번주 감정쓰레기 개수 계산
    func calculateThisWeekEmotionTrashCount() -> Int {
        let calendar = Calendar.current
        let now = Date()

        // 이번 주의 시작과 끝 날짜 계산
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) {

            return fetchEmotionTrashCount(user: SignInService.shared.signedInUser!, startDate: startOfWeek, endDate: endOfWeek)
            print("startOfWeek: \(startOfWeek), endOfWeek: \(endOfWeek)")
        } else {
            return 0
        }
    }

    // 지난주 감정쓰레기 개수 계산
    func calculateLastWeekEmotionTrashCount() -> Int {
        let calendar = Calendar.current
        let now = Date()

        // 현재 날짜가 속한 주의 시작 날짜 계산
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) {

            // 지난 주의 시작과 끝 날짜 계산
            if let startOfLastWeek = calendar.date(byAdding: .day, value: -7, to: startOfWeek),
                let endOfLastWeek = calendar.date(byAdding: .day, value: 6, to: startOfLastWeek) {

                return fetchEmotionTrashCount(user: SignInService.shared.signedInUser!, startDate: startOfLastWeek, endDate: endOfLastWeek)
                print("startOfLastWeek: \(startOfLastWeek), endOfLastWeek: \(endOfLastWeek)")
            }
        }
        return 0
    }
    
    // 일주일 전과 이번주 감정쓰레기 비교
    func compareWeek() -> Int {
        let thisWeekEmotionTrashCount = calculateThisWeekEmotionTrashCount()
        let lastWeekEmotionTrashCount = calculateLastWeekEmotionTrashCount()
        
        return thisWeekEmotionTrashCount - lastWeekEmotionTrashCount
    }

    // 요일별 감정쓰레기 개수 비교
    func calculateDaysOfWeekCount() -> [String: Int] {
        var daysOfWeekCount: [String: Int] = [:]

        for emotionTrash in fetchTotalEmotionTrashes(SignInService.shared.signedInUser!) {
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

    // 시간대별 감정쓰레기 개수 비교
    func calculateTimeZoneCount() -> [String: Int] {
        var timeZoneCount: [String: Int] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        for emotionTrash in fetchTotalEmotionTrashes(SignInService.shared.signedInUser!) {
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
