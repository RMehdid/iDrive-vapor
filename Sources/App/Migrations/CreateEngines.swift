//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/12/2023.
//

import Fluent
import Vapor

extension Engine {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("engines")
                .id()
                .field("type", .string, .required)
                .field("transmission", .string, .required)
                .field("horse_power", .int, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("engines")
                .delete()
        }
    }
}
