//
//  ProductsCacher.swift
//  ScandTest
//
//  Created by Alex on 4.11.23.
//

import Foundation

protocol ProductsCacher {
    func save(from productStore: ProductStore?) async throws
    
    func load(to productStore: ProductStore?) async throws
}
