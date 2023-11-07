//
//  OrderNetworkMananger.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation

protocol OrderNetworkMananger {
    associatedtype ID : Hashable
    func sendOrder(order: Order) async throws
    func getAllOrders(forUserID: ID?) async throws -> [Order]
}
