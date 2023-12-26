//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/12/2023.
//

import Fluent
import Vapor

extension Coordinates {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("coordinates")
                .id()
                .field("latitude", .double, .required)
                .field("longitude", .double, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("coordinates")
                .delete()
        }
    }
}


