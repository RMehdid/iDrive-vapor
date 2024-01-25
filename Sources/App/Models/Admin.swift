//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor
import Fluent

final class Admin: Model, Content, Authenticatable {
    static let schema: String = "admins"
    
    @ID
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password_hash")
    var passwordHash: String

    required init() { }

    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }
    
    init(from dto: DTO) throws {
        self.username = dto.username
        self.passwordHash = try Admin.hashPassword(dto.password)
    }
    
    static func hashPassword(_ password: String) throws -> String {
        return try Bcrypt.hash(password)
    }
}
