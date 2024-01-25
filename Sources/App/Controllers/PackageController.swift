//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

extension Package {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let packages = routes.grouped("packages")
            let adminSecured = packages.grouped(AdminToken.asyncAuthenticator(), AdminToken.guardMiddleware())
            
            adminSecured.get(use: index)
            adminSecured.post(use: create)
            adminSecured.put(use: update)
            
            adminSecured.group(":package_id") { package in
                package.delete(use: delete)
            }
        }
        
        func index(req: Request) async throws -> [Package] {
            return try await Package.query(on: req.db).all()
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let package = try req.content.decode(Package.self)
            try await package.save(on: req.db)
            return .ok
        }
        
        func update(req: Request) async throws -> HTTPStatus {
            let package = try req.content.decode(Package.self)
            
            try await Package.find(package.id, on: req.db)
                .flatMap {
                    $0.name = package.name
                    $0.description = package.description
                    $0.initialPeriod = package.initialPeriod
                    $0.initialDistance = package.initialDistance
                    return $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            try await Owner.find(req.parameters.get("package_id"), on: req.db)
                .flatMap { $0.delete(on: req.db) }
            
            return .ok
        }
    }
}
