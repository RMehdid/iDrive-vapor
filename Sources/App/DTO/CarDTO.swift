//
//  CarDTO.swift
//
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Vapor

extension Car {
    struct DTO: Content {
        
        var id: Int
        
        var make: String
        
        var model: String
        
        var year: Int
        
        var fuelLevel: Int
        
        var engineId: UUID
        
        var coordinatesId: UUID?
        
        var imageUrl: String
        
        var ownerId: Int
        
        var status: CarStatus
        
        var rating: Double
        
        var color: String
        
        var isFreeCancelation: Bool
    }
}
