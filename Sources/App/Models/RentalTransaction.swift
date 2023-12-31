//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

final class RentalTransaction: Model, Content {
    
    static let schema: String = "rental_transactions"
    
    @ID
    var id: UUID?
    
    @Parent(key: "car_id")
    var car: Car
    
    @Parent(key: "client_id")
    var client: Client
    
    @Timestamp(key: "start_date", on: .none)
    var startDate: Date?
    
    @Timestamp(key: "end_date", on: .none)
    var endDate: Date?
    
    @Field(key: "total_cost")
    var totalCost: Int
    
    @OptionalField(key: "total_drove")
    var totalDrove: Int?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, car: Car, client: Client, startDate: Date? = nil, endDate: Date? = nil, totalCost: Int, totalDrove: Int? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.car = car
        self.client = client
        self.startDate = startDate
        self.endDate = endDate
        self.totalCost = totalCost
        self.totalDrove = totalDrove
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(dto: DTO) {
        self.$car.id = dto.carId
        self.$client.id = dto.clientId
        self.startDate = dto.startDate
        self.endDate = dto.endDate
        self.totalCost = dto.totalCost
    }
}
