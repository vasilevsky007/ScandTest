//
//  ProductStore.swift
//  ScandTest
//
//  Created by Alex on 4.11.23.
//

import Foundation

actor ProductStore {
    private (set) var items = [Product]() {
        didSet {
            storedProductsChanged()
        }
    }
    
    let storedProductsChanged: () -> Void
    
    init(items: [Product] = [Product](), storedProductsChanged: @escaping () -> Void) {
        self.items = items
        self.storedProductsChanged = storedProductsChanged
    }
    
    func add(_ product: Product) {
        if items.contains(product){
            update(product)
        } else {
            items.append(product)
        }
    }
    
    func remove(_ productToRemove: Product) {
        guard let removingIndex = items.firstIndex(of: productToRemove) else { return }
        items.remove(at: removingIndex)
    }
    
    func update(_ updatedProduct: Product) {
        if let updatingIndex = items.firstIndex(of: updatedProduct){
            if (items[updatingIndex].hashValue != updatedProduct.hashValue){
                items[updatingIndex] = updatedProduct
            }
        } else {
            add(updatedProduct)
        }
    }
}
