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
            return try await Car
                .query(on: req.db)
                .with(\.$engine)
                .with(\.$coordinates)
                .with(\.$owner)
                .all()
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let newCarDto = try req.content
                .decode(Car.DTO.self)
            
            try await Car(dto: newCarDto)
                .save(on: req.db)
            
            return .ok
        }
        
        func getCar(req: Request) async throws -> Car {
            guard let carId = Int(req.parameters.get("car_id") ?? "") else {
                throw Abort(.notFound)
            }
            
            guard let car = try await Car
                .query(on: req.db)
                .with(\.$engine)
                .with(\.$coordinates)
                .with(\.$owner)
                .filter(\Car.$id == carId)
                .first() else {
                throw Abort(.notFound)
            }
            
            return car
        }
        
        func setFuelLevel(req: Request) async throws -> HTTPStatus {
            let fuelLevel = try req.content.decode(Int.self)
            
            guard let car = try await Car.find(req.parameters.get("car_id"), on: req.db) else {
                return .notFound
            }
            
            car.fuelLevel = fuelLevel
            
            try await car.update(on: req.db)
            
            return .ok
        }
        
        func getFuelLevel(req: Request) async throws -> Int {
            guard let car =  try await Car.find(req.parameters.get("car_id"), on: req.db) else {
                throw Abort(.notFound)
            }
               
            return car.fuelLevel
        }
        
        func delete(req: Request) async throws -> HTTPStatus {
            guard let car = try await Car.find(req.parameters.get("car_id"), on: req.db) else {
                return .notFound
            }
            
            try await car.delete(on: req.db)
            
            return .ok
        }
    }
}
