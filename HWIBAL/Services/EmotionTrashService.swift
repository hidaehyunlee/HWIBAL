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
    
    // ⚠️ audioRecording 저장형태에 따라 일부 변경될 수 있음
    func createEmotionTrash(_ user: User, _ text: String, _ image: UIImage? = nil, _ audioRecording: Data? = nil) {
        if let entity = NSEntityDescription.entity(forEntityName: "EmotionTrash", in: context) {
            let newEmotionTrash = EmotionTrash(entity: entity, insertInto: context)
            newEmotionTrash.id = UUID()
            newEmotionTrash.text = text
            newEmotionTrash.timestamp = Date()
            
            if let image = image {
                newEmotionTrash.image = image.pngData()
            }
            
            if let audioRecording = audioRecording {
                newEmotionTrash.audioRecording = audioRecording
            }
            
            newEmotionTrash.user = user
            coreDataManager.saveContext()
        }
    }
    
    func updateEmotionTrash(_ user: User, _ id: UUID, _ text: String, _ image: UIImage? = nil, _ audioRecording: Data? = nil) {
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND user == %@ ", id as CVarArg, user)
        
        do {
            if let emotionTrashToUpdate = try context.fetch(fetchRequest).first {
                emotionTrashToUpdate.text = text
                emotionTrashToUpdate.timestamp = Date()
                
                if let image = image {
                    emotionTrashToUpdate.image = image.pngData()
                }
                
                if let audioRecording = audioRecording {
                    emotionTrashToUpdate.audioRecording = audioRecording
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
}
