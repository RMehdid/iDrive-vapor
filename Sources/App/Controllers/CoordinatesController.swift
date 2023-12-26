//
//  File.swift
//  
//
//  Created by Samy Mehdid on 26/12/2023.
//

import Fluent
import Vapor

extension Coordinates {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let coordinates = routes.grouped("coordinates")
            coordinates.post(use: create)
            
            coordinates.group(":car_id") { car in
                car.delete(use: delete)
            }
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            try await req.content
                .decode(Coordinates.self)
                .save(on: req.db)
            
            return .ok
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            try await Car.find(req.parameters.get("car_id"), on: req.db)
                .flatMap { $0.delete(on: req.db)}
            
            return .ok
        }
    }
}
