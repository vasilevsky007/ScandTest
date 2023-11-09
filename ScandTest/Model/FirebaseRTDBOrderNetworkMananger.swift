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
            .child(order.id.uuidString)
            .setValue(from: order) /* { error  in
                if let error = error {
                    print("error from completion handler: \(error)")
                }
            } */
    }
    
    func listenToNewOrders(ordersUpdatedCallback: @escaping (_ allOrders:[Order])->Void) {
        db.child("orders").observe(.value) { snapshot in
            var orders = [Order]()
            _ = snapshot.children.allObjects.map { snapshot in
                guard let orderSnapshot = snapshot as? DataSnapshot else { return }
                if let orderConverted = try? orderSnapshot.data(as: Order.self) {
                    orders.append(orderConverted)
                }
            }
            ordersUpdatedCallback(orders)
        }
    }
}
