//
//  CarController.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor
import Redis

extension Car {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let cars = routes.grouped("cars")
            cars.get(use: index)
            
            let creat = cars.grouped("create")
            creat.post(use: create)
            
            cars.group(":car_id") { car in
                car.get(use: getCar)
                car.delete(use: delete)
            }
        }
        
        func index(req: Request) async throws -> [Car.Simple] {
            if let searchText = try? req.query.get(String.self, at: "query") {
                print("searching cars for \(searchText)")
                let cars = try await Car
                    .query(on: req.db)
                    .group(.or) { group in
                        group.filter(\Car.$make ~~ searchText)
                        group.filter(\Car.$model ~~ searchText)
                        
                        if let searchNumber = Int(searchText) {
                            group.filter(\Car.$year == searchNumber)
                        }
                    }
                    .field(\.$id)
                    .field(\.$color)
                    .field(\.$model)
                    .field(\.$year)
                    .field(\.$rating)
                    .field(\.$imageUrl)
                    .all()
                
                return cars.map { Car.Simple(car: $0) }
            } else {
                print("getting all cars")
                let cars = try await Car
                    .query(on: req.db)
                    .field(\.$id)
                    .field(\.$color)
                    .field(\.$model)
                    .field(\.$year)
                    .field(\.$rating)
                    .field(\.$imageUrl)
                    .all()
                
                return cars.map { Car.Simple(car: $0) }
            }
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let newCarDto = try req.content
                .decode(Car.DTO.self)
            
            try await Car(dto: newCarDto)
                .save(on: req.db)
            
            return .ok
        }
        
        func getCar(req: Request) async throws -> Car.Response {
            guard let carId = Int(req.parameters.get("car_id") ?? "") else {
                throw Abort(.notFound)
            }
            
            guard let car = try await Car
                .query(on: req.db)
                .with(\.$engine)
                .with(\.$owner)
                .filter(\Car.$id == carId)
                .first() else {
                throw Abort(.notFound)
            }
            
            let packages = try await Pricing
                .query(on: req.db)
                .with(\.$car)
                .with(\.$package)
                .filter(\Pricing.$car.$id == carId)
                .sort(\.$initialPrice)
                .all()
                .map { pricing in
                    Package.Response(pricing)
                }
            
            var carResponse = Car.Response(car: car, packages: packages)
            
            let fuelKey = RedisKey("car_\(carId)_fuel_level")
            let coordinatesKey = RedisKey("car_\(carId)_coordinates")
            
            carResponse.fuelLevel = try await req.redis.get(fuelKey, as: Int.self).get()
            carResponse.coordinates = try await req.redis.get(coordinatesKey, asJSON: Coordinates.self)
            
            return carResponse
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
