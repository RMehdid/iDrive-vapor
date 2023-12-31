//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

final class Pricing: Model, Content {
    
    static let schema: String = "pricing"
    
    @ID
    var id: UUID?
    
    @Parent(key: "car_id")
    var car: Car
    
    @Parent(key: "package_id")
    var package: Package
    
    @Field(key: "initial_price")
    var initialPrice: Int
    
    @Field(key: "price_per_extra_hour")
    var pricePerExtraHour: Int
    
    @Field(key: "price_per_extra_km")
    var pricePerExtraKm: Int
    
    init() { }
    
    init(id: UUID? = nil, car: Car.IDValue, package: Package.IDValue, initialPrice: Int, pricePerExtraHour: Int, pricePerExtraKm: Int) {
        self.id = id
        self.$car.id = car
        self.$package.id = package
        self.initialPrice = initialPrice
        self.pricePerExtraHour = pricePerExtraHour
        self.pricePerExtraKm = pricePerExtraKm
    }
    
    init(dto: DTO) {
        self.$car.id = dto.carId
        self.$package.id = dto.packageId
        self.initialPrice = dto.initialPrice
        self.pricePerExtraHour = dto.pricePerExtraHour
        self.pricePerExtraKm = dto.pricePerExtraKm
    }
}
