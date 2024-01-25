//
//  EngineController.swift
//
//
//  Created by Samy Mehdid on 26/12/2023.
//

import Fluent
import Vapor

extension Engine {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let engines = routes.grouped("engines")
            engines.post(use: create)
            engines.put(use: update)
            
            engines.group(":engine_id") { engine in
                engine.get(use: getEngine)
                engine.delete(use: delete)
            }
        }
        
        func create(req: Request) async throws -> Engine {
            let engine = try req.content.decode(Engine.self)
            
            try await engine.save(on: req.db)
            
            return engine
        }
        
        func getEngine(req: Request) async throws -> Engine {
            guard let engine = try await Engine.find(req.parameters.get("engine_id"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            return engine
        }
        
        func update(req: Request) async throws -> HTTPStatus {
            let engine = try req.content.decode(Engine.self)
            
            try await Engine.find(engine.id, on: req.db)
                .flatMap {
                    $0.type = engine.type
                    $0.transmission = engine.transmission
                    $0.horsePower = engine.horsePower
                    $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            guard let engine = try await Engine.find(req.parameters.get("engine_id"), on: req.db) else {
                throw Abort(.notFound)
            }
            
            try await engine.delete(on: req.db)
            
            return .ok
        }
    }
}

