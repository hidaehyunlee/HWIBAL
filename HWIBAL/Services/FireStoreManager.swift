//
//  FireStoreManager.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/02.
//

import CoreData
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
import Foundation

final class FireStoreManager {
    static let shared = FireStoreManager()
    typealias UserResult = (Result<User, Error>) -> Void
    var signInUser: User?

    // Firestore 데이터베이스 참조
    let db = Firestore.firestore()

    // MARK: - Users

    // 유저 생성 테스트 완료
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
        let user = User(id: userId, name: name, email: email, autoExpireDate: setAutoExpireDate(day: 7) ?? Date())
        FireStoreManager.shared.signInUser = user
    }
    
    // 업데이트 유저 테스트 완료
    func updateUser(userId: String, autoExpireDays: Int) {
        guard let userId = signInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }

        db.collection("Users").document(userId).setData([
            "autoExpireDate": setAutoExpireDate(day: autoExpireDays) ?? Date()
        ], merge: true)
    }
    
    // 유저 삭제 테스트 완료
    func deleteUser(userId: String) {
        guard let userId = signInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }

        deleteAllEmotionTrashOfUser(userId: userId) { error in
            if let error = error {
                print("Error deleting emotion trash: \(error.localizedDescription)")
            } else {
                print("Emotion trash deleted successfully.")
                self.db.collection("Users").document(userId).delete()
                print("User deleted successfully.")
            }
        }
    }
    
    // 유저 존재 여부 T/F - ID로 확인
    func isUserIdExistInFirestore(userId: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                completion(false, error)
            } else if let document = document, document.exists {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    // 유저 존재 여부 T/F - email로 확인
    // 테스트 완료
    func isUserEmailExistInFirestore(email: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                completion(false, error)
            } else {
                // 이메일을 기반으로 검색한 결과가 존재하는지 확인
                let exists = !querySnapshot!.documents.isEmpty
                completion(exists, nil)
            }
        }
    }
    
    func getUser(userId: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
            } else if let document = document, document.exists {
                let userData = document.data()
                let name = userData?["name"] as? String ?? ""
                let email = userData?["email"] as? String ?? ""
                let autoExpireDate = userData?["autoExpireDate"] as? Date ?? Date()

                // 가져온 데이터를 이용하여 User 객체 생성
                let user = User(id: userId, name: name, email: email, autoExpireDate: autoExpireDate)
                
                completion(user, nil)
            } else {
                let error = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                completion(nil, nil)
            }
        }
    }
    
    // 테스트 완료
    func getUserForEmail(email: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let document = querySnapshot?.documents.first, document.exists {
                    let userData = document.data()
                    let name = userData["name"] as? String ?? ""
                    let id = userData["id"] as? String ?? ""
                    let autoExpireDate = userData["autoExpireDate"] as? Date ?? Date()

                    // 가져온 데이터를 이용하여 User 객체 생성
                    let user = User(id: id, name: name, email: email, autoExpireDate: autoExpireDate)
                            
                    completion(user, nil)
                } else {
                    let error = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                    completion(nil, error)
                }
            }
        }
    }
    
    // MARK: - Emotion Trash

    // 감쓰 작성 테스트 완료, 일부 미작동
    func createEmotionTrash(user: User, EmotionTrashesId: String, text: String, image: UIImage? = nil, recording: Recording? = nil) {
        var trashData: [String: Any] = [
            "id": EmotionTrashesId,
            "text": text,
            "timestamp": Date(),
            "user": [
                "id": user.id,
                "name": user.name,
                "email": user.email
            ]
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
        // 녹음빼고 저장됨
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
        
        createReport(user: user, reportId: UUID().uuidString, text: text)
    }
    
    // cellId가 어떤식으로 지정되는지 모르겠음, 테스트 실패
    func deleteEmotionTrash(EmotionTrashesId: String) {
        db.collection("EmotionTrashes").document(EmotionTrashesId).delete()
    }
    
    // 전체 삭제 테스트 완료
    func deleteAllEmotionTrash(completion: @escaping (Error?) -> Void) {
        db.collection("EmotionTrashes").getDocuments { querySnapshot, error in
            if let error = error {
                completion(error)
            } else {
                let batch = self.db.batch()
                for document in querySnapshot!.documents {
                    batch.deleteDocument(document.reference)
                }
                batch.commit { batchError in
                    completion(batchError)
                }
            }
        }
    }
    
    func deleteAllEmotionTrashOfUser(userId: String, completion: @escaping (Error?) -> Void) {
        let emotionTrashCollectionRef = db.collection("EmotionTrashes")
        
        let query = emotionTrashCollectionRef.whereField("user.id", isEqualTo: userId)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                completion(nil)
            }
        }
    }

    
    // 유저의 감쓰 전체를 가져오는 함수
    func fetchEmotionTrashDocuments(userId: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
        let emotionTrashCollectionRef = db.collection("EmotionTrashes")
        
        let query = emotionTrashCollectionRef.whereField("user.id", isEqualTo: userId)
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching emotion trash documents: \(error)")
                completion(nil, error)
            } else {
                if let documents = querySnapshot?.documents {
                    completion(documents, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    // MARK: - Reports

    // 레포트 생성 테스트 완료
    func createReport(user: User, reportId: String, text: String) {
        var reportData: [String: Any] = [
            "id": reportId,
            "text": text,
            "timestamp": Date(),
            "user": [
                "id": user.id,
                "name": user.name,
                "email": user.email
            ]
        ]
        
        db.collection("Reports").document(reportId).setData(reportData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(reportId)")
            }
        }
    }

    // MARK: - FireStore Document 관련 로직

    // 문서 수 반환하는 함수(감쓰 총 개수, 모든 유저의 수 등)
    // 테스트 완료
    func getDocumentCount(collectionName: String, completion: @escaping (Result<Int, Error>) -> Void) {
        db.collection(collectionName).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let documentCount = querySnapshot?.documents.count ?? 0
                completion(.success(documentCount))
            }
        }
    }
    
    // 유저의 감쓰 총 개수 반환하는 함수
    func getEmotionTrashCount(userId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let collectionRef = db.collection("EmotionTrashes").whereField("user.id", isEqualTo: userId)
        
        collectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let documentCount = querySnapshot?.documents.count ?? 0
                completion(.success(documentCount))
            }
        }
    }

    // 컬렉션을 전체 가져오는 함수(유저, 감쓰, 리포트)
    func fetchDocumentsFromCollection(collectionName: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
        db.collection(collectionName).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                completion(nil, error)
            } else {
                if let documents = querySnapshot?.documents {
                    completion(documents, nil)
                } else {
                    completion(nil, nil)
                }
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
    // 테스트 실패
    func uploadRecording(audioFileURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("audio/\(UUID().uuidString).m4a")
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        
        storageRef.putFile(from: audioFileURL, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
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
    // 테스트 완료
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
