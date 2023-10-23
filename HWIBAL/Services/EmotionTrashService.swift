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
    
    // ⚠️ audioRecording 저장형태에 따라 일부 변경될 수 있음
    func createEmotionTrash(_ text: String, _ image: UIImage? = nil, _ recording: Recording? = nil) {
        let context = coreDataManager.persistentContainer.viewContext
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

            coreDataManager.saveContext()
        }
    }
    
    func updateEmotionTrash(_ id: UUID, _ text: String, _ image: UIImage? = nil, _ recording: Recording? = nil) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
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
    
    func fetchAllEmotionTrashes() -> [EmotionTrash] {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching emotionTrashes: \(error)")
            return []
        }
    }
    
    func deleteEmotionTrash(_ id: UUID) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<EmotionTrash> = EmotionTrash.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let deleteEmotionTrash = try context.fetch(fetchRequest).first {
                context.delete(deleteEmotionTrash)
                coreDataManager.saveContext()
            }
        } catch {
            print("Error deleting emotionTrash: \(error)")
        }
    }
    
    func deleteAllEmotionTrash() {
        let context = coreDataManager.persistentContainer.viewContext
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
