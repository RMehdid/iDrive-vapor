//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor
import Fluent

extension LoginCredentials {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let loginRoute = routes.grouped("login")
            
            loginRoute.post(use: login)
            
        }
        
        func login(req: Request) async throws -> TokenReponse {
            let userCredentials = try req.content.decode(LoginCredentials.self)
            
            if let client = try await Client.find(userCredentials.id, on: req.db) {
                guard client.phone == userCredentials.phone else {
                    throw Abort(.custom(code: 401, reasonPhrase: "phone number missmatch"))
                }
                
            } else if let owner = try await Owner.find(userCredentials.id, on: req.db) {
                guard owner.phone == userCredentials.phone else {
                    throw Abort(.custom(code: 401, reasonPhrase: "phone number missmatch"))
                }
                
            } else {
                throw Abort(.custom(code: 400, reasonPhrase: "user not found"))
            }
            
            let payload = SessionToken(userId: userCredentials.id)
            
            return TokenReponse(token: try req.jwt.sign(payload))
        }
    }
}
