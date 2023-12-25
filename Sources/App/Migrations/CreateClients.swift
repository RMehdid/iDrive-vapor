//
//  CreateUsers.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent

extension Client {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("clients")
                .id()
                .field("firstname", .string, .required)
                .field("lastname", .string, .required)
                .field("email", .string)
                .field("phone", .string, .required)
                .field("profile_image_url", .string)
                .field("rating", .double, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("clients")
                .delete()
        }
    }
}


