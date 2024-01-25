//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor
import Fluent
import JWT

enum UserType: String, Codable {
    case client
    case owner
    case admin
}

struct SessionToken: Content, Authenticatable, JWTPayload {

    // Constants
    let expirationTime: TimeInterval = 60 * 15

    // Token Data
    var expiration: ExpirationClaim
    var userId: Int
    var userType: UserType

    init(userId: Int, userType: UserType) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
        self.userType = userType
    }

    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

struct TokenReponse: Content {
    var token: String
}
