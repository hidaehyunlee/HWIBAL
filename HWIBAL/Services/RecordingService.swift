//
//  RecordingService.swift
//  HWIBAL
//
//  Created by 김도윤 on 2023/11/03.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import UIKit

class RecordingService {
    static let shared = RecordingService()
    let fireStoreManager = FireStoreManager.shared

    func createRecording(duration: TimeInterval, title: String, user: User) -> Recording? {
        let filePath = "somePath/\(UUID().uuidString).m4a"
        let recording = Recording(dateRecorded: Date(), duration: duration, filePath: filePath, title: title)

        // Firestore에 Recording 객체를 저장
        let db = Firestore.firestore()
        db.collection("Recordings").addDocument(data: [
            "dateRecorded": recording.dateRecorded,
            "duration": recording.duration,
            "filePath": recording.filePath,
            "title": recording.title,
            "userID": user.id
        ]) { error in
            if let error = error {
                print("Error adding recording: \(error)")
            }
        }
        return recording
    }

    func fetchAllRecordings(completion: @escaping ([Recording]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Recordings").getDocuments { (querySnapshot, error) in
            //Firestore에서 데이터를 조회시 querySnapshot 객체를 통해 쿼리에 응답한 각 문서 데이터 접근
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, error)
            } else {
                var recordings = [Recording]()
                for document in querySnapshot!.documents {
                    // 각 문서를 Recording 객체로 변환
                    let data = document.data()
                    if let dateRecorded = data["dateRecorded"] as? Date,
                       let duration = data["duration"] as? TimeInterval,
                       let filePath = data["filePath"] as? String,
                       let title = data["title"] as? String {
                        let recording = Recording(dateRecorded: dateRecorded, duration: duration, filePath: filePath, title: title)
                        recordings.append(recording)
                    }
                }
                completion(recordings, nil)
            }
        }
    }

    func fetchRecordings(filePath: String, completion: @escaping ([Recording]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Recordings").whereField("filePath", isEqualTo: filePath).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, error)
            } else {
                var recordings = [Recording]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let dateRecorded = data["dateRecorded"] as? Date,
                       let duration = data["duration"] as? TimeInterval,
                       let title = data["title"] as? String {
                        let recording = Recording(dateRecorded: dateRecorded, duration: duration, filePath: filePath, title: title)
                        recordings.append(recording)
                    }
                }
                completion(recordings, nil)
            }
        }
    }
}
