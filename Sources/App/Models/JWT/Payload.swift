//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor
import JWT

struct Payload: JWTPayload, Authenticatable {
    // User-releated stuff
    var id: Int?
    var firstname: String
    var lastname: String
    var phone: String
    var rating: Double
    
    // JWT stuff
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    init(with client: Client) throws {
        self.id = client.id
        self.firstname = client.firstname
        self.lastname = client.lastname
        self.phone = client.phone
        self.rating = client.rating
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(Constants.ACCESS_TOKEN_LIFETIME))
    }
    
    init(with owner: Owner) throws {
        self.id = owner.id
        self.firstname = owner.firstname
        self.lastname = owner.lastname
        self.phone = owner.phone
        self.rating = owner.rating
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(Constants.ACCESS_TOKEN_LIFETIME))
    }
}

extension Client {
    convenience init(from payload: Payload) {
        self.init(id: payload.id, firstname: payload.firstname, lastname: payload.lastname, phone: payload.phone, rating: payload.rating)
    }
}

extension Owner {
    convenience init(from payload: Payload) {
        self.init(id: payload.id, firstname: payload.firstname, lastname: payload.lastname, phone: payload.phone, rating: payload.rating)
    }
}
