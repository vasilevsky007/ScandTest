//
//  User.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation

struct User: Codable, Hashable, Identifiable {
    struct Address: Codable, Hashable {
        var street: String
        var house: String
        var apartament: String?
        
        init(street: String, house: String, apartament: String?) {
            self.street = street
            self.house = house
            self.apartament = apartament
        }
    }
    //actually, user id should be gotten bu authentification
    private(set) var id: UUID
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String?
    var address: Address
    
    init(id:UUID = UUID(), firstName: String, lastName: String, phoneNumber: String, email: String?, adress: Address) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = adress
    }
}
