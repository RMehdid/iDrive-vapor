//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

extension Pricing {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let pricings = routes.grouped("pricings")
            pricings.post(use: create)
            pricings.put(use: update)
            
            pricings.group(":car_id") { car in
                car.get(use: getCarPackagesPricings)
            }
        }
        
        func getCarPackagesPricings(req: Request) async throws -> [Pricing] {
            guard let carId = Int(req.parameters.get("car_id") ?? "") else {
                throw Abort(.notFound)
            }
            
            return try await Pricing.query(on: req.db)
                .with(\.$package)
                .with(\.$car)
                .filter(\Pricing.$car.$id == carId)
                .all()
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let newPricingDto = try req.content
                .decode(Pricing.DTO.self)
            
            try await Pricing(dto: newPricingDto)
                .save(on: req.db)
            
            return .ok
        }
        
        func update(req: Request) async throws -> HTTPStatus {
            let pricing = try req.content.decode(Pricing.self)
            
            try await Pricing.find(pricing.id, on: req.db)
                .flatMap {
                    $0.car.id = pricing.car.id
                    $0.package.id = pricing.package.id
                    $0.initialPrice = pricing.initialPrice
                    $0.pricePerExtraHour = pricing.pricePerExtraHour
                    $0.pricePerExtraKm = pricing.pricePerExtraKm
                    return $0.update(on: req.db)
                }
            
            return .ok
        }
        
//        func delete(req: Request) async throws -> HTTPStatus {
//            try await Pricing.find(req.parameters.get("pricing_id"), on: req.db)
//                .flatMap { $0.delete(on: req.db) }
//            
//            return .ok
//        }
    }
}
