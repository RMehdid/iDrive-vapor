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
        
        var engineId: UUID
        
        var imageUrl: String
        
        var ownerId: Int
        
        var status: CarStatus
        
        var rating: Double
        
        var color: String
        
        var isFreeCancelation: Bool
    }
}

extension Car {
    struct Response: Content {
        
        var id: Int?
        
        var make: String
        
        var model: String
        
        var year: Int
        
        var fuelLevel: Int?
        
        var engine: Engine
        
        var coordinates: Coordinates?
        
        var imageUrl: String
        
        var owner: Owner
        
        var status: CarStatus
        
        var rating: Double
        
        var color: String
        
        var isFreeCancelation: Bool
        
        var packages: [Package.Response]
        
        init(car: Car, fuelLevel: Int? = nil, coordinates: Coordinates? = nil, packages: [Package.Response]) {
            self.id = car.id
            self.make = car.make
            self.model = car.model
            self.year = car.year
            self.fuelLevel = fuelLevel
            self.engine = car.engine
            self.coordinates = coordinates
            self.imageUrl = car.imageUrl
            self.owner = car.owner
            self.status = car.status
            self.rating = car.rating
            self.color = car.color
            self.isFreeCancelation = car.isFreeCancelation
            self.packages = packages
        }
    }
}

extension Car {
    struct Simple: Content {
        var id: Int?
        var model: String
        var color: String
        var imageUrl: String
        var year: Int
        var rating: Double
        
        init(car: Car) {
            self.id = car.id
            self.model = car.model
            self.color = car.color
            self.imageUrl = car.imageUrl
            self.year = car.year
            self.rating = car.rating
        }
    }
}
