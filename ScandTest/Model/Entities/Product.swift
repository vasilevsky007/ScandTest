//
//  Product.swift
//  ScandTest
//
//  Created by Alex on 4.11.23.
//

import Foundation

struct Product: Equatable, Hashable, Identifiable, Codable {
    
    enum Photo: Codable, Equatable, Hashable {
        case url(URL)
        case image(data: Data?)
    }
    
    private(set) var id = UUID()
    
    var name: String
    var price: Double
    var photo: Photo?
    var description: String?
    
    
    init(name: String, price: Double, photo: Photo? = nil, description: String? = nil) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.photo = photo
        self.description = description
    }
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    @MainActor mutating func saveImage(_ data: Data?, fromUrl url: URL) {
        if let photo = photo, photo == .url(url) {
            self.photo = .image(data: data)
        }
    }
}
