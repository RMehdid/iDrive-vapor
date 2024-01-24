//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct AccessTokenRequest: Content {
    let refreshToken: String
}
