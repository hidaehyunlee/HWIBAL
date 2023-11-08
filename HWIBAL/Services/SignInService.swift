//
//  SignInService.swift
//  HWIBAL
//
//  Created by t2023-m0076 on 2023/10/18.
//

import Foundation

class SignInService {
    static let shared = SignInService()
    
    var signedInUser: User?
    
    func signIn(_ email: String, _ name: String, _ id: String, completion: @escaping () -> Void) {
        if let existUser = UserService.shared.getExistUserAsId(id) { // ID로 찾는 로직으로 변경
            print("이미 가입한 회원")
            signedInUser = existUser
            setSignedInUser(existUser.id!)
            UserDefaults.standard.set(false, forKey: "isDarkMode")
            UserDefaults.standard.set(7, forKey: "autoExpireDays_\(String(describing: SignInService.shared.signedInUser?.id))")
            UserService.shared.printAllUsers()
            
            completion()
        } else {
            FireBaseManager.shared.isUserIdExistInFirestore(userId: id) { exists, error in
                if let error = error {
                    print("Error checking user ID existence: \(error.localizedDescription)")
                } else {
                    if exists {
                        print("User ID exists in Firestore")
                        FireBaseManager.shared.getUserForUserId(id: id) { user, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else if let user = user {
                                print("🚨User ID: \(user.id)")
                                print("User Name: \(user.name)")
                                print("User Email: \(user.email)")
                                
                                completion()
                            }
                        }
                    } else {
                        print("User ID does not exist in Firestore")
                        FireBaseManager.shared.createUser(email: email, name: name, userId: id, autoExpireDate: Date() + 7 * 24 * 60 * 60, joinOfDate: Date(), lastSignInDate: Date())
                        UserService.shared.createUser(email: email, name: name, id: id)
                        self.signedInUser = UserService.shared.getExistUserAsId(id)
                        self.setSignedInUser(id)
                        UserDefaults.standard.set(false, forKey: "isDarkMode")
                        UserDefaults.standard.set(7, forKey: "autoExpireDays_\(String(describing: SignInService.shared.signedInUser?.id))")
                        UserService.shared.printAllUsers()
                        
                        completion()
                    }
                }
            }
        }
    }
    
    func setSignedInUser(_ id: String) {
        UserDefaults.standard.set(id, forKey: "loadSignedInUserId")
        UserDefaults.standard.set(true, forKey: "isSignedIn")
    }
    
    func SetOffAutoSignIn(_ id: String) {
        UserDefaults.standard.set(id, forKey: "loadSignedInUserId")
        UserDefaults.standard.set(false, forKey: "isSignedIn")
    }
    
    func setWithdrawal() {
        UserDefaults.standard.set("N/A", forKey: "loadSignedInUserId")
        UserDefaults.standard.set(false, forKey: "isSignedIn")
    }
    
    func isSignedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSignedIn")
    }
    
    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: "isDarkMode")
    }

    func loadSignedInUserId() -> String? {
        return UserDefaults.standard.string(forKey: "loadSignedInUserId")
    }
    
    func getSignedInUserInfo() {
        print("--------------------------------")
        print("""
        👤 [로그인 유저 정보]
        Email: \(signedInUser?.email ?? "No email")
        Name: \(signedInUser?.name ?? "No name")
        ID: \(signedInUser?.id ?? "No ID")
        자동 휘발일: \(String(describing: signedInUser?.autoExpireDate))
        """)
        print("--------------------------------")
    }
}
