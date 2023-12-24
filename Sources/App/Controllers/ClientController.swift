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
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Client]> {
        return Client.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let client = try req.content.decode(Client.self)
        return client.save(on: req.db).transform(to: .ok)
    }
}
