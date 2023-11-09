//
//  UserCacher.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import Foundation

protocol UserCacher {
    func save(_ user: User) async throws
    
    func load() async throws -> User? 
}
