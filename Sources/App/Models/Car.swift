//
//  Car.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Car: Model, Content {
    
    static let schema: String = "cars"
    
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
    
    @Parent(key: "engine_id")
    var engine: Engine
    
    @OptionalParent(key: "coordinates_id")
    var coordinates: Coordinates?
    
    @Field(key: "image_url")
    var imageUrl: URL
    
    @Parent(key: "owner_id")
    var owner: Owner
    
    @Enum(key: "status")
    var status: CarStatus
    
    @Field(key: "rating")
    var rating: Double
    
    @Field(key: "color")
    var color: String
    
    @Field(key: "is_free_cancelation")
    var isFreeCancelation: Bool
    
    init() { }
    
    init(id: UUID? = nil, make: String, model: String, year: Int, fuelLevel: Int, engineId: UUID, coordinatesId: UUID? = nil, imageUrl: URL, ownerId: UUID, status: CarStatus, rating: Double, color: String, isFreeCancelation: Bool) {
        self.id = id
        self.make = make
        self.model = model
        self.year = year
        self.fuelLevel = fuelLevel
        self.$engine.id = engineId
        self.$coordinates.id = coordinatesId
        self.imageUrl = imageUrl
        self.$owner.id = ownerId
        self.status = status
        self.rating = rating
        self.color = color
        self.isFreeCancelation = isFreeCancelation
    }
}
