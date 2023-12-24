//
//  UserControllrt.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

struct ClientController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let clients = routes.grouped("clients")
        clients.get(use: index)
        clients.post(use: create)
        clients.put(use: update)
        
        clients.group(":userId") { client in
            client.delete(use: delete)
        }
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Client]> {
        return Client.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let client = try req.content.decode(Client.self)
        return client.save(on: req.db).transform(to: .ok)
    }
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let client = try req.content.decode(Client.self)
        
        return Client.find(client.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.firstname = client.firstname
                $0.lastname = client.lastname
                $0.email = client.email
                $0.phone = client.phone
                $0.profileImageUrl = client.profileImageUrl
                $0.rating = client.rating
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Client.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db)}
            .transform(to: .ok)
    }
}
