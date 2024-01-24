//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct UserDTO: Content {
    let id: Int?
    let firstname: String
    let lastname: String
    let phone: String
    
    init(id: Int? = nil, firstname: String, lastname: String, phone: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.phone = phone
    }
    
    init(from user: Client) {
        self.init(id: user.id, firstname: user.firstname, lastname: user.lastname, phone: user.phone)
    }
    
    init(from user: Owner) {
        self.init(id: user.id, firstname: user.firstname, lastname: user.lastname, phone: user.phone)
    }
}
