//
//  Order.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation


struct Order: Codable, Hashable, Identifiable {
    private(set) var id: UUID
    var products: [Product]
    var user: User
    var comment: String?
    var time: Date
    
    init(products: [Product], user: User, comment: String?) {
        self.id = UUID()
        self.products = products
        self.user = user
        self.comment = comment
        self.time = Date.now
    }
}
