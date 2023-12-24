//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Engine: Fields {
    
    @Enum(key: "type")
    var type: EngineType
    
    @Enum(key: "transmission")
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
