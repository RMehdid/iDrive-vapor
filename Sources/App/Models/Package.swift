//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

final class Package: Model, Content {
    
    static let schema: String = "packages"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "initial_period")
    var initialPeriod: Int
    
    @Field(key: "initial_distance")
    var initialDistance: Int
    
    init() { }
    
    init(id: UUID? = nil, name: String, description: String, initialPeriod: Int, initialDistance: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.initialPeriod = initialPeriod
        self.initialDistance = initialDistance
    }
}
