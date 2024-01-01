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
    
    @ID(custom: .id, generatedBy: .user)
    var id: Int?
    
    @Field(key: "make")
    var make: String
    
    @Field(key: "model")
    var model: String
    
    @Field(key: "year")
    var year: Int
    
    @Parent(key: "engine_id")
    var engine: Engine
    
    @Field(key: "image_url")
    var imageUrl: String
    
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
    
    init(id: Int? = nil, make: String, model: String, year: Int, engineId: UUID, imageUrl: String, ownerId: Int, status: CarStatus, rating: Double, color: String, isFreeCancelation: Bool) {
        self.id = id
        self.make = make
        self.model = model
        self.year = year
        self.$engine.id = engineId
        self.imageUrl = imageUrl
        self.$owner.id = ownerId
        self.status = status
        self.rating = rating
        self.color = color
        self.isFreeCancelation = isFreeCancelation
    }
    
    init(dto: DTO) {
        self.id = dto.id
        self.make = dto.make
        self.model = dto.model
        self.year = dto.year
        self.$engine.id = dto.engineId
        self.imageUrl = dto.imageUrl
        self.$owner.id = dto.ownerId
        self.status = dto.status
        self.rating = dto.rating
        self.color = dto.color
        self.isFreeCancelation = dto.isFreeCancelation
    }
}
