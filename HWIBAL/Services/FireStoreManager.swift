//
//  FireStoreManager.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/02.
//

import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import Foundation
import CoreData
import FirebaseStorage

final class FireStoreManager {
    static let shared = FireStoreManager()
    typealias UserResult = (Result<User, Error>) -> Void

    // Firestore 데이터베이스 참조
    let db = Firestore.firestore()

    // MARK: - Users
    func createUser(email: String, name: String, userId: String) {

        db.collection("Users").document(userId).setData([
            "name": name,
            "email": email,
            "id": userId,
            "autoExpireDate": setAutoExpireDate(day: 7) ?? Date()
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(userId)")
            }
        }
    }
    
    func updateUser(userId: String, autoExpireDays: Int) {
        guard let userId = SignInService.shared.signedInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }
        
        db.collection("Users").document(userId).setData([
            "autoExpireDate": setAutoExpireDate(day: autoExpireDays) ?? Date()
        ], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated with new autoExpireDays: \(String(describing: SignInService.shared.signedInUser?.autoExpireDate))")
            }
        }
    }
    
    func deleteUser(userId: String) {
        guard let userId = SignInService.shared.signedInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }
        
        db.collection("Users").document(userId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted: \(userId)")
            }
        }
    }
    
    // 🤔 이거는 다시 한번 확인 필요함. 코어데이터 모델 안지우고는 이게 최선이나, 리턴값을 불러오기 힘듦.
    // 🚨 코어데이터 지우고 별도의 모델을 다시 구성할 때 Codable 프로토콜 채택 필수
    func getUser(userId: String, completion: @escaping UserResult) {
        db.collection("Users").document(userId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let userData = document.data()
                let name = userData?["name"] as? String ?? ""
                let email = userData?["email"] as? String ?? ""
                let autoExpireDate = userData?["autoExpireDate"] as? Date ?? Date()

                // 가져온 데이터를 이용하여 User 객체 생성
                let context = CoreDataManager.shared.persistentContainer.viewContext
                if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
                    let user = User(entity: entity, insertInto: context)
                    user.id = userId
                    user.name = name
                    user.email = email
                    user.autoExpireDate = autoExpireDate
                
                    // 완료 클로저 호출하여 사용자 데이터 반환
                    completion(.success(user))
                }
            } else {
                // 문서가 존재하지 않는 경우
                let error = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Emotion Trash
    func createEmotionTrash(user: User, EmotionTrashesId: String, text: String, image: UIImage? = nil, recording: Recording? = nil) {
        var trashData: [String: Any] = [
            "id": EmotionTrashesId,
            "text": text,
            "timestamp": Date(),
            "user": [ "id": user.id ]
        ]
        
        // 🚨 이미지 처리 안되고 있음 ㅠ
        // 이미지 업로드 및 URL 추가
        
        // 이 로직은 아예 데이터 저장이 안됨
        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            trashData["image"] = imageData.base64EncodedString()
        }
        
        // 이 로직은 이미지 빼고 저장됨
//        if let image = image {
//            uploadImage(image: image) { result in
//                switch result {
//                case .success(let imageURL):
//                    trashData["image"] = imageURL.absoluteString
//                case .failure(let error):
//                    print("Error uploading image: \(error.localizedDescription)")
//                }
//            }
//        }
            
        // 녹음 파일 업로드 및 URL 추가
        if let recordingURL = recording?.filePath {
            let recordingFileURL = URL(fileURLWithPath: recordingURL)
            uploadRecording(audioFileURL: recordingFileURL) { result in
                switch result {
                case .success(let audioURL):
                    trashData["audioURL"] = audioURL.absoluteString
                case .failure(let error):
                    print("Error uploading audio file: \(error.localizedDescription)")
                }
            }
        }
        
        db.collection("EmotionTrashes").document(EmotionTrashesId).setData(trashData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(EmotionTrashesId)")
            }
        }
    }
    
    // MARK: - FireStore Document 관련 로직
    // 문서 수 반환하는 함수(감쓰 총 개수, 모든 유저의 수 등)
    func getDocumentCount(forCollection collectionName: String, completion: @escaping (Result<Int, Error>) -> Void) {
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let documentCount = querySnapshot?.documents.count ?? 0
                completion(.success(documentCount))
            }
        }
    }
    
    
    // MARK: - Firebase Storage 관련 로직(이미지, 녹음)
    // 이미지 처리
//    func uploadImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
//            return
//        }
//
//        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                storageRef.downloadURL { (url, error) in
//                    if let downloadURL = url {
//                        completion(.success(downloadURL))
//                    } else if let error = error {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
//    }
    
    // 녹음 처리
    func uploadRecording(audioFileURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("audio/\(UUID().uuidString).m4a")
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        
        storageRef.putFile(from: audioFileURL, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(.success(downloadURL))
                    } else if let error = error {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // MARK: - 추가 세팅 함수
    // 자동 휘발일 초기 설정 함수
    func setAutoExpireDate(day: Int) -> Date? {
        if let sevenDaysLater = Calendar.current.date(byAdding: .day, value: day, to: Date()) {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: sevenDaysLater)

            if let year = components.year, let month = components.month, let day = components.day {
                return Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0))
            }
        }
        return nil
    }
    
}
