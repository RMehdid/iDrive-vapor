//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/1/2024.
//

import Vapor

struct UserDTO: Content {
    let id: Int
    let firstname: String
    let lastname: String
    let phone: String
    
    init(id: Int, firstname: String, lastname: String, phone: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.phone = phone
    }
}

extension Client {
    convenience init(from userDto: UserDTO) throws {
        self.init(id: userDto.id, firstname: userDto.firstname, lastname: userDto.lastname, phone: userDto.phone, rating: 5.0)
    }
}

extension Owner {
    convenience init(from userDto: UserDTO) throws {
        self.init(id: userDto.id, firstname: userDto.firstname, lastname: userDto.lastname, phone: userDto.phone, rating: 5.0)
    }
}
