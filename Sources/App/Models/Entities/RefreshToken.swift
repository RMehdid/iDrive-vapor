//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor
import Fluent

final class ClientRefreshToken: Model {
    static let schema = "client_refresh_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String
    
    @Parent(key: "client_id")
    var client: Client
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Field(key: "issued_at")
    var issuedAt: Date
    
    init() {}
    
    init(id: UUID? = nil, token: String, clientID: Int, expiresAt: Date = Date().addingTimeInterval(Constants.REFRESH_TOKEN_LIFETIME), issuedAt: Date = Date()) {
        self.id = id
        self.token = token
        self.$client.id = clientID
        self.expiresAt = expiresAt
        self.issuedAt = issuedAt
    }
}

final class OwnerRefreshToken: Model {
    static let schema = "owner_refresh_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String
    
    @Parent(key: "owner_id")
    var owner: Owner
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Field(key: "issued_at")
    var issuedAt: Date
    
    init() {}
    
    init(id: UUID? = nil, token: String, ownerID: Int, expiresAt: Date = Date().addingTimeInterval(Constants.REFRESH_TOKEN_LIFETIME), issuedAt: Date = Date()) {
        self.id = id
        self.token = token
        self.$owner.id = ownerID
        self.expiresAt = expiresAt
        self.issuedAt = issuedAt
    }
}
