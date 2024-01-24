//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct LoginResponse: Content {
    let user: UserDTO
    let accessToken: String
    let refreshToken: String
}
