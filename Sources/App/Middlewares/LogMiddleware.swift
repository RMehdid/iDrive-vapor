//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor

struct LogMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        print(request)
        
        return try await next.respond(to: request)
    }
}
