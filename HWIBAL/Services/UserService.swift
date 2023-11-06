//
//  UserService.swift
//  HWIBAL
//
//  Created by daelee on 10/13/23.
//

import CoreData
import Foundation

class UserService {
    static let shared = UserService()
    let coreDataManager = CoreDataManager.shared

    func createUser(email: String, name: String, id: String) {
        let context = coreDataManager.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let user = User(entity: entity, insertInto: context)
            user.email = email
            user.name = name
            user.id = id
            user.autoExpireDate = setAutoExpireDate(day: 8)
            
            
            if let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 8, to: Date()) {
                let components = Calendar.current.dateComponents([.year, .month, .day], from: sevenDaysLater)
                
                if let year = components.year, let month = components.month, let day = components.day {
                    if let sevenDaysLaterMidnight = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)) {
                        user.autoExpireDate = sevenDaysLaterMidnight
                    }
                }
            }

            coreDataManager.saveContext()
        }
    }

    func updateUser(email: String, autoExpireDays: Int? = nil) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            if let userToUpdate = try context.fetch(fetchRequest).first {
                userToUpdate.autoExpireDate = setAutoExpireDate(day: (autoExpireDays ?? 7) + 1)

                coreDataManager.saveContext()
                print("""
                유저 정보가 업데이트되었습니다.
                Email: \(userToUpdate.email ?? "No email")
                Name: \(userToUpdate.name ?? "No name")
                ID: \(userToUpdate.id ?? "No ID")
                AutoExpireDate: \(String(describing: userToUpdate.autoExpireDate))
                """)
            } else {
                print("Error fetching users: \(email)")
            }
        } catch {
            print("Error updating user: \(error)")
        }
    }

    // 이메일에 해당하는 사용자가 있으면 해당 사용자를 반환, 없으면 nil 반환
    func getExistUser(_ email: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            return users.first(where: { $0.email == email })
        } catch {
            print("Error fetching users: \(error)")
            return nil
        }
    }
    
    func getExistUserAsId(_ id: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let users = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            return users.first(where: { $0.id == id })
        } catch {
            print("Error fetching users: \(error)")
            return nil
        }
    }

    func fetchAllUsers() -> [User] {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }

    func printAllUsers() {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                print("User -")
                print("Email: \(user.email ?? "No email"), Name: \(user.name ?? "No name"), ID: \(user.id ?? "No ID"), AutoExpireDate: \(String(describing: user.autoExpireDate))")
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }

    func deleteUser(_ email: String) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            if let deleteUser = try context.fetch(fetchRequest).first {
                context.delete(deleteUser)
                print("삭제된 유저: ", deleteUser.email as Any)
                coreDataManager.saveContext()
                printAllUsers()
            } else {
                print("User not found.")
            }
        } catch {
            print("Error deleting user: \(error)")
        }
    }
    
    // 자동 휘발일 설정
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
