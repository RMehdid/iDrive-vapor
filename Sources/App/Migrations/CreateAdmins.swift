//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor
import Fluent

extension Admin {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("admins")
                .id()
                .field("username", .string, .required)
                .field("password_hash", .string, .required)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("admins")
                .delete()
        }
    }
}

