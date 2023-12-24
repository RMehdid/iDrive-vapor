//
//  Car.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Car: Model, Content {
    
    static let schema = "cars"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "make")
    var make: String
    
    @Field(key: "model")
    var model: String
    
    @Field(key: "year")
    var year: Int
    
    @Field(key: "fuel_level")
    var fuelLevel: Int
    
    @Field(key: "engine")
    var engine: Engine
    
    @Field(key: "coordinates")
    var coordinates: Coordinates
    
    @Field(key: "image_url")
    var imageUrl: String
    
    @Field(key: "owner_id")
    var ownerId: String
    
    @Field(key: "status")
    var status: CarStatus
    
    @Field(key: "rating")
    var rating: Double
    
    @Field(key: "color")
    var color: String
    
    @Field(key: "is_free_cancelation")
    var isFreeCancelation: Bool
}
