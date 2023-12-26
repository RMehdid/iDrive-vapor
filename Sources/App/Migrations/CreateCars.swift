//
//  CreateCars.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent

extension Car {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("cars")
                .field(.id, .int, .required)
                .field("make", .string, .required)
                .field("model", .string, .required)
                .field("year", .int, .required)
                .field("fuel_level", .int, .required)
                .field("image_url", .string)
                .field("engine_id", .uuid, .foreignKey("engines", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("coordinates_id", .uuid, .foreignKey("coordinates", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("owner_id", .int, .foreignKey("owners", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("rating", .double, .required)
                .field("status", .string, .required)
                .field("color", .string, .required)
                .field("is_free_cancelation", .bool, .required)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("cars")
                .delete()
        }
    }
}

