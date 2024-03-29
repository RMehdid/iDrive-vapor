//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor
import Fluent

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let loginRoute = routes.grouped("login")
        
        loginRoute.group(":type") {
            $0.post(use: loginUser)
        }
        
        loginRoute.group("admin") {
            $0.post(use: loginAdmin)
        }
        
        loginRoute.group("car") {
            $0.post(use: loginCar)
        }
    }
    
    func loginUser(req: Request) async throws -> TokenReponse {
        let userCredentials = try req.content.decode(UserCredentials.self)
        
        guard let type = req.parameters.get("type"), let userType = UserType(rawValue: type) else {
            throw Abort(.custom(code: 400, reasonPhrase: "user type missing"))
        }
        
        switch userType {
        case .client:
            guard let client = try await Client.find(userCredentials.id, on: req.db) else {
                throw Abort(.custom(code: 400, reasonPhrase: "client not found"))
            }
            guard client.phone == userCredentials.phone else {
                throw Abort(.custom(code: 401, reasonPhrase: "phone number missmatch"))
            }
        case .owner:
            guard let owner = try await Owner.find(userCredentials.id, on: req.db) else {
                throw Abort(.custom(code: 400, reasonPhrase: "owner not found"))
            }
            
            guard owner.phone == userCredentials.phone else {
                throw Abort(.custom(code: 401, reasonPhrase: "phone number missmatch"))
            }
        }
        
        let payload = SessionToken(userId: userCredentials.id, userType: userType)
        
        return TokenReponse(token: try req.jwt.sign(payload))
    }
    
    func loginAdmin(req: Request) async throws -> TokenReponse {
        let adminCredentials = try req.content.decode(AdminCredentials.self)
        
        guard let admin = try await Admin.query(on: req.db)
            .filter(\.$username == adminCredentials.username)
            .first() else {
            throw Abort(.unauthorized, reason: "username not found")
        }
        
        guard try Bcrypt.verify(adminCredentials.password, created: admin.passwordHash) else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        let payload = AdminToken(username: admin.username)
        
        return TokenReponse(token: try req.jwt.sign(payload))
    }
    
    func loginCar(req: Request) async throws -> TokenReponse {
        let carCredentials = try req.content.decode(CarCredentials.self)
        
        guard let car = try await Car.find(carCredentials.id, on: req.db) else {
            throw Abort(.custom(code: 400, reasonPhrase: "car not found"))
        }
        
        guard car.owner.id == carCredentials.ownerId else {
            throw Abort(.custom(code: 401, reasonPhrase: "owner id missmatch"))
        }
        
        let payload = CarToken(carCredentials.id)
        
        return TokenReponse(token: try req.jwt.sign(payload))
    }
}
