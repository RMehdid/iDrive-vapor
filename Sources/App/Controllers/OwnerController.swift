//
//  OwnerController.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

extension Owner {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let owners = routes.grouped("owners")
            owners.get(use: index)
            owners.post(use: create)
            owners.put(use: update)
            
            owners.post("login") { req -> TokenReponse in
                let user = try req.auth.require(Owner.self)
                let payload = try SessionToken(userId: user.requireID())
                return TokenReponse(token: try req.jwt.sign(payload))
            }
            
            owners.group(":owner_id") { owner in
                owner.delete(use: delete)
            }
        }
        
        func index(req: Request) async throws -> [Owner] {
            return try await Owner.query(on: req.db).all()
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let owners = try req.content.decode(Owner.self)
            try await owners.save(on: req.db)
            return .ok
        }
        
        func update(req: Request) async throws -> HTTPStatus {
            let owner = try req.content.decode(Owner.self)
            
            try await Owner.find(owner.id, on: req.db)
                .flatMap {
                    $0.firstname = owner.firstname
                    $0.lastname = owner.lastname
                    $0.email = owner.email
                    $0.phone = owner.phone
                    $0.profileImageUrl = owner.profileImageUrl
                    $0.rating = owner.rating
                    $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            try await Owner.find(req.parameters.get("owner_id"), on: req.db)
                .flatMap { $0.delete(on: req.db) }
            
            return .ok
        }
    }
}
