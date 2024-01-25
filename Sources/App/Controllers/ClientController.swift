//
//  UserControllrt.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

extension Client {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let clients = routes.grouped("clients")
            clients.get(use: index)
            clients.post(use: create)
            clients.put(use: update)
            
            clients.group("me") { me in
                let securedMe = me.grouped(SessionToken.authenticator(), SessionToken.guardMiddleware())
                securedMe.get(use: getMe)
            }
            
            clients.group(":client_id") { client in
                client.delete(use: delete)
            }
        }
        
        func getMe(req: Request) async throws -> Client {
            let payload = try req.jwt.verify(as: SessionToken.self)
            
            guard let client = try await Client.find(payload.userId, on: req.db) else {
                throw Abort(.badRequest)
            }
            
            return client
        }
        
        func index(req: Request) async throws -> [Client] {
            return try await Client.query(on: req.db).all()
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let client = try req.content.decode(Client.self)
            try await client.save(on: req.db)
            
            return .ok
        }
        
        func update(req: Request) async throws -> HTTPStatus {
            let client = try req.content.decode(Client.self)
            
            try await Client.find(client.id, on: req.db)
                .flatMap {
                    $0.firstname = client.firstname
                    $0.lastname = client.lastname
                    $0.email = client.email
                    $0.phone = client.phone
                    $0.profileImageUrl = client.profileImageUrl
                    $0.rating = client.rating
                    $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            try await Client.find(req.parameters.get("client_id"), on: req.db)
                .flatMap { $0.delete(on: req.db)}
                
            return .ok
        }
    }
}
