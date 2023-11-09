//
//  OrderNetworkMananger.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation

protocol OrderNetworkMananger {
    func sendOrder(order: Order) async throws
    func listenToNewOrders(ordersUpdatedCallback: @escaping (_ allOrders:[Order])->Void)
}
