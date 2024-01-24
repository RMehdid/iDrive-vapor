//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor
import Fluent
import JWT

struct SessionToken: Content, Authenticatable, JWTPayload {

    // Constants
    let expirationTime: TimeInterval = 60 * 15

    // Token Data
    var expiration: ExpirationClaim
    var userId: Int

    init(userId: Int) {
        self.userId = userId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}

struct TokenReponse: Content {
    var token: String
}
