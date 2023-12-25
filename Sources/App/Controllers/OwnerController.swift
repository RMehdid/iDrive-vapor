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
        owners.put(use: update)
        
        owners.group(":owner_id") { owner in
            owner.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Owner] {
        return try await Owner.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus {
        let owners = try req.content.decode(Owner.self)
        return try await owners.save(on: req.db).transform(to: .ok).get()
    }
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let owner = try req.content.decode(Owner.self)
        
        return Owner.find(owner.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.firstname = owner.firstname
                $0.lastname = owner.lastname
                $0.email = owner.email
                $0.phone = owner.phone
                $0.profileImageUrl = owner.profileImageUrl
                $0.rating = owner.rating
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Owner.find(req.parameters.get("owner_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db)}
            .transform(to: .ok)
    }
}
