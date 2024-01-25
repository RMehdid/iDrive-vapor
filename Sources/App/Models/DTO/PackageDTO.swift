//
//  File.swift
//  
//
//  Created by Samy Mehdid on 2/1/2024.
//

import Vapor

extension Package {
    struct Response: Content {
        
        var id: UUID?
        
        var name: String
        
        var description: String
        
        var initialPeriod: Int
        
        var initialDistance: Int
        
        var pricing: Pricing.Response
        
        init(_ pricing: Pricing) {
            self.id = pricing.package.id
            self.name = pricing.package.name
            self.description = pricing.package.description
            self.initialPeriod = pricing.package.initialPeriod
            self.initialDistance = pricing.package.initialDistance
            self.pricing = Pricing.Response(pricing)
        }
    }
}
