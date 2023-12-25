//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Engine: Model, Content {
    
    static var schema: String = "engines"
    
    @ID(key: .id)
    var id: UUID?
    
    @Enum(key: "type")
    var type: EngineType
    
    @Enum(key: "transmission")
    var transmission: Transmission
    
    @Field(key: "horse_power")
    var horsePower: Int
    
    init() { }
    
    init(id: UUID? = nil, type: EngineType, transmission: Transmission, horsePower: Int) {
        self.id = id
        self.type = type
        self.transmission = transmission
        self.horsePower = horsePower
    }
}
