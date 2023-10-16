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

    func createUser(email: String, name: String, id: String, autoLoginEnabled: Bool, autoExpireDays: Int64) {
        let context = coreDataManager.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let user = User(entity: entity, insertInto: context)
            user.email = email
            user.name = name
            user.id = id
            user.autoLoginEnabled = autoLoginEnabled
            user.autoExpireDays = autoExpireDays

            coreDataManager.saveContext()
        }
    }

    func isUserExist(_ email: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Error fetching users: \(error)")
            return false
        }
    }

    func printAllUsers() {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                print("User -")
                print("Email: \(user.email ?? "No email"), Name: \(user.name ?? "No name"), ID: \(user.id ?? "No ID"), AutoLoginEnabled: \(user.autoLoginEnabled), AutoExpireDays: \(user.autoExpireDays)")
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
}
