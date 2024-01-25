//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor

extension Admin {
    struct DTO: Content {
        var username: String
        var password: String
    }
}

extension Admin {
    struct Response: Content {
        var id: UUID
        var username: String
        
        init(_ admin: Admin) throws {
            self.id = try admin.requireID()
            self.username = admin.username
        }
    }
}
