//
//  Product.swift
//  ScandTest
//
//  Created by Alex on 4.11.23.
//

import Foundation

struct Product: Equatable, Hashable, Identifiable, Codable {
    private(set) var id = UUID()
    
    init(name: String, price: Double, photo: Data? = nil, description: String? = nil) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.photo = photo
        self.description = description
    }
    
    var name: String
    var price: Double
    var photo: Data?
    var description: String?
}
