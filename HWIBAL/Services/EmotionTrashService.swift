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
    
    // ⚠️ audioRecording 저장형태에 따라 일부 변경될 수 있음
    func createEmotionTrash(_ user: User, _ text: String, _ image: UIImage? = nil, _ recordingFilePath: String? = nil) {
        if let entity = NSEntityDescription.entity(forEntityName: "EmotionTrash", in: context),
           let reportEntity = NSEntityDescription.entity(forEntityName: "Report", in: context) {
            let newEmotionTrash = EmotionTrash(entity: entity, insertInto: context)
            newEmotionTrash.id = UUID()
            newEmotionTrash.text = text
            newEmotionTrash.timestamp = Date()
            
            if let image = image {
                newEmotionTrash.image = image.pngData()
            }
            
            if let recordingFilePath = recordingFilePath {
                newEmotionTrash.recording?.filePath = recordingFilePath
            }
            
            newEmotionTrash.user = user
            
            let newReport = Report(entity: reportEntity, insertInto: context)
            newReport.id = UUID()
            newReport.text = text
            newReport.timestamp = Date()
            newReport.user = user
    
            coreDataManager.saveContext()
        }
    }
    
    func updateEmotionTrash(_ user: User, _ id: UUID, _ text: String, _ image: UIImage? = nil, _ recordingFilePath: String? = nil) {
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND user == %@ ", id as CVarArg, user)
        
        do {
            if let emotionTrashToUpdate = try context.fetch(fetchRequest).first {
                emotionTrashToUpdate.text = text
                emotionTrashToUpdate.timestamp = Date()
                
                if let image = image {
                    emotionTrashToUpdate.image = image.pngData()
                }
                
                if let recordingFilePath = recordingFilePath {
                    emotionTrashToUpdate.recording?.filePath = recordingFilePath
                }
                coreDataManager.saveContext()
            }
        } catch {
            print("Error updating emotionTrash: \(error)")
        }
    }
    
    // delete: 유저의 감정쓰레기 개별 삭제
    func deleteEmotionTrash(_ user: User, _ id: UUID) {
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
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
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
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
    
    // 자동 휘발 로직
    func startAutoDeleteTask(_ day: Int) {
        print("""
              📢 [자동 삭제 알림] \(day)일 후 삭제 예정 📢
              """)
        // 백그라운드에서 실행될 함수를 호출할 타이머 설정 -> withTimeInterval: * 60 * 60 * 24 처리하면 autoExpireDays일 후 실행, repeats: true로 변경
        // (테스트 코드) Double((SignInService.shared.signedInUser?.autoExpireDays ?? 7)) * 5, repeats: false
        Timer.scheduledTimer(withTimeInterval: Double(day) * 5, repeats: false) { _ in
            // 원하는 주기(예: n일 간격)로 실행될 코드 작성
            
            
            // 이건 포그라운드로 들어올때 실행되니까 ! 노티 따로 삭제로직 따로 하면 되겠다!!!
            print("백그라운드에서 실행 중...")
            DispatchQueue.main.async {
                print("삭제 로직 실행")
                EmotionTrashService.shared.deleteTotalEmotionTrash(SignInService.shared.signedInUser!)
                NotificationCenter.default.post(name: NSNotification.Name("EmotionTrashUpdate"), object: nil)
                print("삭제 완료")
                NotificationService.shared.autoDeleteNotification()
                print("자동 휘발 노티 알림 발송")
            }
            
        }
    }
    
    // fetch: 유저의 전체 감정쓰레기 가져오기
    func fetchTotalEmotionTrashes(_ user: User) -> [EmotionTrash] {
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching emotionTrashes: \(error)")
            return []
        }
    }
    
    // fetch: 모든 유저의 전체 감정쓰레기 가져오기
    func fetchAllUsersEmotionTrashes() -> [EmotionTrash] {
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
        
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
    func deleteAllUsersEmotionTrash() {
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
        
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
}
