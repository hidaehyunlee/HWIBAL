//
//  RecordingService.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/11/05.
//

import Foundation
import CoreData
import UIKit

class RecordingService {
    static let shared = RecordingService()
    let coreDataManager = CoreDataManager.shared
    let emotionTrashService = EmotionTrashService.shared

    func createRecording(filePath: String, duration: TimeInterval, title: String, user: User) -> Recording? {
        let context = coreDataManager.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Recording", in: context) {
            let recording = Recording(entity: entity, insertInto: context)
            recording.filePath = filePath
            recording.duration = duration
            recording.title = title
            recording.dateRecorded = Date()

            coreDataManager.saveContext()
            
            return recording
        }
        return nil
    }

    func fetchAllRecordings() -> [Recording] {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching recordings: \(error)")
            return []
        }
    }
    
    func fetchRecordings(filePath: String) -> [Recording] {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "filePath == %@", filePath)

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching recordings with filePath \(filePath): \(error)")
            return []
        }
    }
}


