//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Vapor

extension RentalTransaction {
    struct DTO: Content {
        var carId: Int
        var clientId: Int
        var startDate: Date
        var endDate: Date
        var totalCost: Int
    }
}
