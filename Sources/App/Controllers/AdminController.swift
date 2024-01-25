//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor

extension Admin {
    struct AdminController: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let admins = routes.grouped("admins")
            let secured = admins.grouped(AdminToken.asyncAuthenticator(), AdminToken.guardMiddleware())
            
            secured.post("create", use: create)
            
            secured.group(":admin_id") { admin in
                admin.delete(use: delete)
            }
        }
        
        func create(req: Request) async throws -> Admin.Response {
            let adminDto = try req.content.decode(Admin.DTO.self)
            
            let admin = try Admin(from: adminDto)
            try await admin.save(on: req.db)
            
            return try Admin.Response(admin)
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            guard let admin = try await Admin.find(req.parameters.get("admin_id"), on: req.db) else {
                return .notFound
            }
            
            try await admin.delete(on: req.db)
            
            return .ok
        }
    }
}
