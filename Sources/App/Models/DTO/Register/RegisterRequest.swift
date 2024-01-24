//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct RegisterRequest: Content {
    let id: Int
    let firstname: String
    let lastname: String
    let phone: String
}

extension RegisterRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: String.self, is: .count(18...18))
        validations.add("firstname", as: String.self, is: .count(3...))
        validations.add("lastname", as: String.self, is: .count(3...))
        validations.add("phone", as: String.self, is: .count(13...13))
    }
}

extension Client {
    convenience init(from register: RegisterRequest) throws {
        self.init(id: register.id, firstname: register.firstname, lastname: register.lastname, phone: register.phone, rating: 5.0)
    }
}

extension Owner {
    convenience init(from register: RegisterRequest) throws {
        self.init(id: register.id, firstname: register.firstname, lastname: register.lastname, phone: register.phone, rating: 5.0)
    }
}
