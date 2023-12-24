//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Engine: Model {
    
    static let schema: String = "engines"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: EngineType
    
    @Field(key: "transmission")
    var transmission: Transmission
    
    @Field(key: "horse_power")
    var horsePower: Int
    
    init() { }
    
    init(type: EngineType, transmission: Transmission, horsePower: Int) {
        self.type = type
        self.transmission = transmission
        self.horsePower = horsePower
    }
}
