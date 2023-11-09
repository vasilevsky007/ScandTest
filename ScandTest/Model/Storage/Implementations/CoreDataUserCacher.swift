//
//  CoreDataUserCacher.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation
import CoreData

class CoreDataUserCacher: UserCacher {
    
    init?(context: NSManagedObjectContext?) {
        if let context = context {
            self.context = context
        } else {
            return nil
        }
    }
    
    private var context: NSManagedObjectContext
    
    private func deleteAllOld() throws {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        try context.execute(batchDeleteRequest)
        try context.save()
    }
    
    func save(_ user: User) async throws {
        try? deleteAllOld()
        let userEntity = NSEntityDescription.entity(forEntityName: "UserEntity", in: context)!
        let userManagedObject = NSManagedObject(entity: userEntity, insertInto: context)
        
        userManagedObject.setValue(user.id, forKey: "id")
        userManagedObject.setValue(user.firstName, forKey: "firstName")
        userManagedObject.setValue(user.lastName, forKey: "lastName")
        userManagedObject.setValue(user.phoneNumber, forKey: "phoneNumber")
        userManagedObject.setValue(user.email, forKey: "email")
        userManagedObject.setValue(user.address.street, forKey: "street")
        userManagedObject.setValue(user.address.house, forKey: "house")
        userManagedObject.setValue(user.address.apartament, forKey: "apartament")
        try context.save()
    }
    
    func load() async throws -> User? {
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        let userEntities = try context.fetch(fetchRequest)
        
        let users = userEntities.map { userEntity in
            let id = userEntity.value(forKey: "id") as! UUID
            let firstName = userEntity.value(forKey: "firstName") as! String
            let lastName = userEntity.value(forKey: "lastName") as! String
            let phoneNumber = userEntity.value(forKey: "phoneNumber") as! String
            let email = userEntity.value(forKey: "email") as? String
            
            let street = userEntity.value(forKey: "street") as! String
            let house = userEntity.value(forKey: "house") as! String
            let apartament = userEntity.value(forKey: "apartament") as! String?
            
            let address = User.Address(street: street, house: house, apartament: apartament)
            
            return User(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, adress: address)
        }
        return users.last
    }
}
