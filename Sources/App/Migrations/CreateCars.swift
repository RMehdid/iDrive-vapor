//
//  CreateCars.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent

struct CreateCars: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("cars")
            .id()
            .field("make", .string, .required)
            .field("model", .string, .required)
            .field("year", .int, .required)
            .field("fuelLevel", .int, .required)
            .field("engine", .custom(Engine.self), .required)
            .field("coordinates", .custom(Coordinates.self))
            .field("image_url", .string)
            .field("owner_id", .string, .foreignKey("owners", .key("id"), onDelete: .setNull, onUpdate: .cascade))
            .field("rating", .double, .required)
            .field("status", .custom(CarStatus.self), .required)
            .field("color", .string, .required)
            .field("is_free_cancelation", .bool, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("users")
            .delete()
    }
}
