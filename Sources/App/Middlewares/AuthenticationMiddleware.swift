//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor

struct AuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let authorization = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        print(authorization.token)
        return try await next.respond(to: request)
    }
}
