//
//  FirebaseRTDBOrderNetworkMananger.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseRTDBOrderNetworkMananger: OrderNetworkMananger {
    private let db = Database.database(url: "https://scandtest-37a4f-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    func sendOrder(order: Order) async throws {
        try db.child("orders")
            .child(order.user.id.uuidString)
            .child(order.id.uuidString)
            .setValue(from: order)
    }
    
    func getAllOrders(forUserID: UUID? = nil) async throws -> [Order] {
        []
    }
}
