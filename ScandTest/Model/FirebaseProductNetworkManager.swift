//
//  FirebaseProductNetworkManager.swift
//  ScandTest
//
//  Created by Alex on 4.11.23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


class FirebaseProductNetworkManager: ProductNetworkManager {
    
    private let db: Firestore
    
    init() {
        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    func loadAllProducts() async throws -> [Product] {
        let documents = try await db.collection("products").getDocuments().documents
        var products = [Product]()
        for document in documents {
            if let productFromDocument = try? document.data(as: Product.self) {
                products.append(productFromDocument)
            }
        }
        return products
    }
    
    func addProduct(_ product: Product) async throws {
        try db.collection("products")
            .document(product.id.uuidString)
            .setData(from: product)
    }
    
    func deleteProduct(_ product: Product) async throws {
        try await db.collection("products")
            .document(product.id.uuidString)
            .delete()
    }
    
    func updateProduct(_ product: Product) async throws {
        try db.collection("products")
            .document(product.id.uuidString)
            .setData(from: product)
    }
}
