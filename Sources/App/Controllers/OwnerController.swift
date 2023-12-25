//
//  OwnerController.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

struct OwnerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let owners = routes.grouped("owners")
        owners.get(use: index)
        owners.post(use: create)
    }
    
    func index(req: Request) async throws -> [Owner] {
        return try await Owner.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus {
        let owners = try req.content.decode(Owner.self)
        return try await owners.save(on: req.db).transform(to: .ok).get()
    }
}
