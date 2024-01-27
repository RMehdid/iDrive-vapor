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
            let secured = owners.grouped(SessionToken.asyncAuthenticator(), SessionToken.guardMiddleware())
            
            secured.get(use: index)
            owners.post(use: create)
            secured.put(use: update)
            
            secured.group("me") { me in
                me.get(use: getMe)
            }
            
            secured.group(":owner_id") { owner in
                owner.delete(use: delete)
            }
        }
        
        func getMe(req: Request) async throws -> Owner {
            let payload = try req.jwt.verify(as: SessionToken.self)
            
            guard let owner = try await Owner.find(payload.userId, on: req.db) else {
                throw Abort(.badRequest)
            }
            
            return owner
        }
        
        func index(req: Request) async throws -> [Owner] {
            return try await Owner.query(on: req.db).all()
        }
        
        func create(req: Request) async throws -> Owner {
            let owner = try Owner(from: req.content.decode(UserDTO.self))
            
            if try await Owner.find(owner.id, on: req.db) != nil {
                throw Abort(.badRequest, reason: "user already exists")
            } else {
                try await owner.save(on: req.db)
            }
            
            return owner
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
            try await Owner.find(req.parameters.get("owner_id"), on: req.db)?
                .delete(on: req.db)
            
            return .ok
        }
    }
}
