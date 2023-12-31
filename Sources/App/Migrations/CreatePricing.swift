//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

extension Pricing {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("pricing")
                .id()
                .field("car_id", .int, .foreignKey("cars", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("package_id", .uuid, .foreignKey("packages", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("initial_price", .int, .required)
                .field("price_per_extra_hour", .int, .required)
                .field("price_per_extra_km", .int, .required)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("pricing")
                .delete()
        }
    }
}
