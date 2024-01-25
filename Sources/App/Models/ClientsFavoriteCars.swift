//
//  File.swift
//  
//
//  Created by Samy Mehdid on 25/1/2024.
//

import Vapor
import Fluent

final class ClientsFavoriteCars: Model, Content {
    
    static let schema: String = "clients_favorite_cars"
    
    @ID
    var id: UUID?
    
    @Parent(key: "client_id")
    var client: Client
    
    @Parent(key: "car_id")
    var car: Car
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init(id: UUID? = nil, clientId: Client.IDValue, carId: Car.IDValue) {
        self.id = id
        self.$client.id = clientId
        self.$car.id = carId
    }
    
    init() { }
}
