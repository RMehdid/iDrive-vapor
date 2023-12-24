//
//  CreateOwners.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent

struct CreateOwners: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("owners")
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
        return database.schema("owners")
            .delete()
    }
}
