//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor

struct UserCredentials: Authenticatable, Decodable {
    let id: Int
    let phone: String
}

struct AdminCredentials: Authenticatable, Decodable {
    let username: String
    let password: String
}

struct CarCredentials: Authenticatable, Decodable {
    let id: Int
    let ownerId: Int
}
