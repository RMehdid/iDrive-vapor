//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct LoginRequest: Content {
    let id: String
    let phone: String
}

extension LoginRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: String.self, is: .valid)
        validations.add("phone", as: String.self, is: .valid)
    }
}
