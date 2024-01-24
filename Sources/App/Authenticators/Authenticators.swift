//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct ClientAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.Client
    
    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {
        if bearer.token == "foo" {
            request.auth.login(Client(firstname: "Samy", lastname: "Mehdid", phone: "+213540408051", rating: 5.0))
        }
    }
}

