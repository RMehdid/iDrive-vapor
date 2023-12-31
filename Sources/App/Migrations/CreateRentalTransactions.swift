//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

extension RentalTransaction {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("rental_transactions")
                .id()
                .field("car_id", .int, .foreignKey("cars", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("client_id", .int, .foreignKey("clients", .key("id"), onDelete: .noAction, onUpdate: .noAction))
                .field("start_date", .datetime, .required)
                .field("end_date", .datetime, .required)
                .field("total_cost", .int, .required)
                .field("total_drove", .int)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .unique(on: .id)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("rental_transactions")
                .delete()
        }
    }
}

