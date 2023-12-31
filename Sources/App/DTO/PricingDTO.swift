//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Vapor

extension Pricing {
    struct DTO: Content {
        
        var carId: Int
        
        var packageId: UUID
        
        var initialPrice: Int
        
        var pricePerExtraHour: Int
        
        var pricePerExtraKm: Int
    }
}
