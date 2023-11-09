//
//  ProductNetworkManager.swift
//  ScandTest
//
//  Created by Alex on 4.11.23.
//

import Foundation

protocol ProductNetworkManager {
    func loadAllProducts() async throws  -> [Product]
    func addProduct(_ product: Product) async throws
    func deleteProduct(_ product: Product) async throws
    func updateProduct(_ product: Product) async throws
}
