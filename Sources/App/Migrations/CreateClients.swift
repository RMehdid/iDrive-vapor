//
//  CreateUsers.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent

extension Client {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("clients")
                .field(.id, .int, .required)
                .field("firstname", .string, .required)
                .field("lastname", .string, .required)
                .field("email", .string)
                .field("phone", .string, .required)
                .field("profile_image_url", .string)
                .field("rating", .double, .required)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("clients")
                .delete()
        }
    }
}


