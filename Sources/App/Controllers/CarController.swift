//
//  CarController.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

extension Car {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let cars = routes.grouped("cars")
            cars.get(use: index)
            cars.post(use: create)
            
            cars.group(":car_id") { car in
                car.get(use: getCar)
                car.delete(use: delete)
                
                let fuelLevel = car.grouped("fuel_level")
                
                fuelLevel.put(use: setFuelLevel)
                fuelLevel.get(use: getFuelLevel)
            }
        }
        
        func index(req: Request) async throws -> [Car] {
            return try await Car.query(on: req.db).all()
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            try await req.content
                .decode(Car.self)
                .save(on: req.db)
            
            return .ok
        }
        
        func getCar(req: Request) async throws -> Car {
            return try await .find(req.parameters.get("car_id"), on: req.db)
                .unsafelyUnwrapped
        }
        
        func setFuelLevel(req: Request) async throws -> HTTPStatus {
            let fuelLevel = try req.content.decode(Int.self)
            
            try await Car.find(req.parameters.get("car_id"), on: req.db)
                .flatMap {
                    $0.fuelLevel = fuelLevel
                    return $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func getFuelLevel(req: Request) async throws -> Int {
            return try await Car.find(req.parameters.get("car_id"), on: req.db)
                .unsafelyUnwrapped
                .fuelLevel
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            try await Car.find(req.parameters.get("car_id"), on: req.db)
                .flatMap { $0.delete(on: req.db)}
            
            return .ok
        }
    }
}
