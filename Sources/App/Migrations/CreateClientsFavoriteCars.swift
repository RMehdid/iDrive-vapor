//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor
import Fluent

extension ClientsFavoriteCars {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("clients_favorite_cars")
                .id()
                .field("client_id", .int, .foreignKey("clients", .key("id"), onDelete: .setNull, onUpdate: .noAction))
                .field("car_id", .int, .foreignKey("cars", .key("id"), onDelete: .setNull, onUpdate: .noAction))
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("clients_favorite_cars")
                .delete()
        }
    }
}

