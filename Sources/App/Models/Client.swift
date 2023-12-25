//
//  User.swift
//
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Client: Model, Content {
    static let schema: String = "clients"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "firstname")
    var firstname: String
    
    @Field(key: "lastname")
    var lastname: String
    
    @OptionalField(key: "email")
    var email: String?
    
    @Field(key: "phone")
    var phone: String
    
    @OptionalField(key: "profile_image_url")
    var profileImageUrl: URL?
    
    @Field(key: "rating")
    var rating: Double
    
    required init() { }
    
    init(id: UUID? = nil, firstname: String, lastname: String, email: String? = nil, phone: String, profileImageUrl: URL? = nil, rating: Double) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.phone = phone
        self.profileImageUrl = profileImageUrl
        self.rating = rating
    }
}
