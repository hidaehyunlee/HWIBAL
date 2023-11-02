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
    
    func signIn(_ email: String, _ name: String, _ id: String) {
        if let existUser = UserService.shared.getExistUser(email) {
            print("이미 가입한 회원")
            signedInUser = existUser
            setSignedInUser(existUser.email!)
        } else {
            UserService.shared.createUser(email: email, name: name, id: id)
            signedInUser = UserService.shared.getExistUser(email)
            setSignedInUser(email)
            UserDefaults.standard.set(false, forKey: "isDarkMode")
            UserDefaults.standard.set(7, forKey: "autoExpireDays_\(String(describing: SignInService.shared.signedInUser?.email))")
            UserService.shared.printAllUsers()
        }
        NotificationCenter.default.post(name: NSNotification.Name("UserSignIn"), object: nil)
    }
    
    func setSignedInUser(_ email: String) {
        UserDefaults.standard.set(email, forKey: "loadSignedInUserEmail")
        UserDefaults.standard.set(true, forKey: "isSignedIn")
    }
    
    func SetOffAutoSignIn(_ email: String) {
        UserDefaults.standard.set(email, forKey: "loadSignedInUserEmail")
        UserDefaults.standard.set(false, forKey: "isSignedIn")
    }
    
    func setWithdrawal() {
        UserDefaults.standard.set("N/A", forKey: "loadSignedInUserEmail")
        UserDefaults.standard.set(false, forKey: "isSignedIn")
    }
    
    func isSignedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSignedIn")
    }

    func loadSignedInUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: "loadSignedInUserEmail")
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
