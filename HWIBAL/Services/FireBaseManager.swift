//
//  FireBaseManager.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/11/08.
//

import CoreData
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

final class FireBaseManager {
    static let shared = FireBaseManager()
    typealias UserResult = (Result<User, Error>) -> Void
    var reportEmotionTrashes: [Report] = []

    // Firestore 데이터베이스 참조
    let db = Firestore.firestore()

    // MARK: - Users

    // 유저 생성
    func createUser(email: String, name: String, userId: String, autoExpireDate: Date, joinOfDate: Date, lastSignInDate: Date) {
        db.collection("Users").document(userId).setData([
            "name": name,
            "email": email,
            "id": userId,
            "autoExpireDate": autoExpireDate,
            "joinOfDate": joinOfDate,
            "lastSignInDate": lastSignInDate
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(userId)")
            }
        }
    }
    
    // 업데이트 - 유저 자동 휘발 날짜
    func updateUser(userId _: String, autoExpireDays: Int) {
        guard let userId = SignInService.shared.signedInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }

        db.collection("Users").document(userId).setData([
            "autoExpireDate": setAutoExpireDate(day: autoExpireDays + 1) as Any
        ], merge: true)
    }
    
    // 업데이트 - 마지막 로그인 기록
    func updateLastSignInDateOfUser(userId _: String, lastSignInDate: Date) {
        guard let userId = SignInService.shared.signedInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }

        db.collection("Users").document(userId).setData([
            "lastSignInDate": lastSignInDate
        ], merge: true)
    }
    
    // 업데이트 - 마지막 로그인 기록
    func updateLastWrittenDateOfUser(userId _: String, lastWrittenDate: Date) {
        guard let userId = SignInService.shared.signedInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }

        db.collection("Users").document(userId).setData([
            "lastWrittenDate": lastWrittenDate
        ], merge: true)
    }
    
    // 유저 삭제
    func deleteUser(userId _: String) {
        guard let userId = SignInService.shared.signedInUser?.id else {
            print("User ID is nil, cannot save to Firestore")
            return
        }
        self.db.collection("Users").document(userId).delete()
        print("User deleted successfully.")

        deleteAllReportOfUser(userId: userId) { error in
            if let error = error {
                print("Error deleting emotion trash: \(error.localizedDescription)")
            } else {
                print("Emotion trash deleted successfully.")
                
            }
        }
    }
    
    // id로 유저 찾기
    func getUserForId(userId: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
            } else if let document = document, document.exists {
                let userData = document.data()
                let name = userData?["name"] as? String ?? ""
                let email = userData?["email"] as? String ?? ""
                let autoExpireDate = userData?["autoExpireDate"] as? Date ?? Date()

                // 가져온 데이터를 이용하여 CoreData User 객체 생성
                UserService.shared.createUser(email: email, name: name, id: userId)
                let user = UserService.shared.getExistUserAsId(userId)
                
                completion(user, nil)
            } else {
                let error = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                completion(nil, error)
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
    
    // id로 유저 찾기
    func getUserForUserId(id: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("Users").whereField("userId", isEqualTo: id).getDocuments { querySnapshot, error in
            if let error = error {
                print("에러")
                completion(nil, error)
            } else {
                if let document = querySnapshot?.documents.first, document.exists {
                    let userData = document.data()
                    let name = userData["name"] as? String ?? ""
                    let id = userData["id"] as? String ?? ""
                    let autoExpireDate = userData["autoExpireDate"] as? Date ?? Date()

                    // 가져온 데이터를 이용하여 CoreData User 객체 생성
                    UserService.shared.createUser(email: id, name: name, id: id)
                    let user = UserService.shared.getExistUserAsId(id)
                            
                    completion(user, nil)
                } else {
                    let error = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                    print("데이터 로드에러")
                    completion(nil, error)
                }
            }
        }
    }
    
    // MARK: - Reports

    // 레포트 생성 테스트 완료
    func createReport(user: User, reportId: String, text: String) {
        let reportData: [String: Any] = [
            "id": reportId,
            "text": text,
            "timestamp": Date(),
            "userId": user.id ?? ""
        ]
        
        db.collection("Reports").document(reportId).setData(reportData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(reportId)")
                self.updateLastWrittenDateOfUser(userId: user.id!, lastWrittenDate: Date())
            }
        }
    }
    
    // 유저의 감쓰 리포트 전체 삭제
    func deleteAllReportOfUser(userId: String, completion: @escaping (Error?) -> Void) {
        let reportCollectionRef = db.collection("Reports")
        
        let query = reportCollectionRef.whereField("userId", isEqualTo: userId)
        
        query.getDocuments { querySnapshot, error in
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
    
    // MARK: - FireStore Document 관련 로직

    // 문서 수 반환하는 함수(감쓰 리포트 총 개수, 모든 유저의 수 등)
    func getDocumentCount(collectionName: String, completion _: @escaping (Int) -> Void) {
        db.collection(collectionName).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let documentCount = querySnapshot?.documents.count ?? 0
                print("Document count: \(documentCount)")
            }
        }
    }
    
    // 유저의 감쓰 총 개수 반환하는 함수(리포트)
    func getEmotionTrashCountOfUser(userId: String, completion: @escaping (Int) -> Void) {
        let query = db.collection("Reports").whereField("user.id", isEqualTo: userId)
        let countQuery = query.count
        
        countQuery.getAggregation(source: .server) { snapshot, error in
            if let error = error {
                print(error)
                completion(0)
            } else {
                let countDecimal = snapshot?.count ?? 0
                completion(Int(truncating: countDecimal))
            }
        }
    }

    // 컬렉션을 전체 가져오는 함수(유저, 리포트)
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
