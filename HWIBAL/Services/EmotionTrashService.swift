//
//  EmotionTrashService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/19.
//

import CoreData
import Foundation
import UIKit

class EmotionTrashService {
    static let shared = EmotionTrashService()
    let coreDataManager = CoreDataManager.shared
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
    
    private weak var autoDeleteTimer: Timer?
    
    private init() {
        // 앱을 종료해도 남아있어야 함 -> 조금 더 고민해볼 필요가 있음(메모리 사용이 많을 듯)
        autoDeleteTimer = Timer.scheduledTimer(timeInterval: 24 * 60 * 60, target: self, selector: #selector(autoDeleteExpiredEmotionTrash), userInfo: User.self, repeats: true)
//        autoDeleteTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(autoDeleteExpiredEmotionTrash), userInfo: User.self, repeats: true) // 테스트용
        print("타이머 실행")
    }
    
    @objc private func autoDeleteExpiredEmotionTrash() {
        let user = SignInService.shared.signedInUser!
        let expirationDays = user.autoExpireDays
        
        autoDeleteEmotionTrash(user, expirationDays)
    }
    
    // ⚠️ audioRecording 저장형태에 따라 일부 변경될 수 있음
    func createEmotionTrash(_ user: User, _ text: String, _ image: UIImage? = nil, _ recording: Recording? = nil) {
        if let entity = NSEntityDescription.entity(forEntityName: "EmotionTrash", in: context) {
            let newEmotionTrash = EmotionTrash(entity: entity, insertInto: context)
            newEmotionTrash.id = UUID()
            newEmotionTrash.text = text
            newEmotionTrash.timestamp = Date()
            
            if let image = image {
                newEmotionTrash.image = image.pngData()
            }
            
            if let recording = recording {
                newEmotionTrash.recording = recording
            }
            
            newEmotionTrash.user = user
            coreDataManager.saveContext()
        }
    }
    
    func updateEmotionTrash(_ user: User, _ id: UUID, _ text: String, _ image: UIImage? = nil, _ recording: Recording? = nil) {
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND user == %@ ", id as CVarArg, user)
        
        do {
            if let emotionTrashToUpdate = try context.fetch(fetchRequest).first {
                emotionTrashToUpdate.text = text
                emotionTrashToUpdate.timestamp = Date()
                
                if let image = image {
                    emotionTrashToUpdate.image = image.pngData()
                }
                
                if let recording = recording {
                    emotionTrashToUpdate.recording = recording
                }
                coreDataManager.saveContext()
            }
        } catch {
            print("Error updating emotionTrash: \(error)")
        }
    }
    
    // delete: 유저의 감정쓰레기 개별 삭제
    func deleteEmotionTrash(_ user: User, _ id: UUID) {
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND user == %@", id as CVarArg, user)
        
        do {
            if let deleteEmotionTrash = try context.fetch(fetchRequest).first {
                context.delete(deleteEmotionTrash)
                coreDataManager.saveContext()
            }
        } catch {
            print("Error deleting emotionTrash: \(error)")
        }
    }
    
    // delete: 유저의 감정쓰레기 전체 삭제
    func deleteTotalEmotionTrash(_ user: User) {
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        
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
    
    // auto delete: 유저의 감정쓰레기 자동 삭제
    func autoDeleteEmotionTrash(_ user: User, _ day: Int64) {
        let totalEmotionTrashes = fetchTotalEmotionTrashes(user)
        let currentTime = Date()
        
        for emotionTrash in totalEmotionTrashes {
            if let expirationDate = calculateExpirationDate(emotionTrash, day) {
                if currentTime > expirationDate {
                    deleteEmotionTrash(user, emotionTrash.id!)
                    print("삭제")
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
    }
    
    func calculateExpirationDate(_ emotionTrash: EmotionTrash, _ day: Int64) -> Date? {
        let expirationDate = emotionTrash.timestamp?.addingTimeInterval(Double(day) * 24 * 60 * 60)
//        let expirationDate = emotionTrash.timestamp?.addingTimeInterval(10) // 테스트용
        
        return expirationDate
    }
    
    // fetch: 유저의 전체 감정쓰레기 가져오기
    func fetchTotalEmotionTrashes(_ user: User) -> [EmotionTrash] {
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching emotionTrashes: \(error)")
            return []
        }
    }
    
    // fetch: 모든 유저의 전체 감정쓰레기 가져오기
    func fetchAllEmotionTrashes() -> [EmotionTrash] {
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching emotionTrashes: \(error)")
            return []
        }
    }
    
    // print: 유저의 전체 감정쓰레기 출력
    func printTotalEmotionTrashes(_ user: User) {
        let emotionTrashes = fetchTotalEmotionTrashes(user)
        for emotionTrash in emotionTrashes {
            print("EmotionTrashes -")
            print("""
            text: \(emotionTrash.text ?? "")
            timestamp: \(emotionTrash.timestamp ?? Date())
            """)
        }
    }
    
    // MARK: - ⚠️ 관리자용

    // delete: 모든 유저의 감정쓰레기 전체 삭제
    func deleteAllEmotionTrash() {
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
    
    deinit {
        autoDeleteTimer?.invalidate()
        print("타이머 종료")
    }
}
