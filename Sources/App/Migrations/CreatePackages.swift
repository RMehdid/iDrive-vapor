//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

extension Package {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("packages")
                .id()
                .field("name", .string, .required)
                .field("description", .string, .required)
                .field("initial_period", .int, .required)
                .field("initial_distance", .int, .required)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("packages")
                .delete()
        }
    }
}
