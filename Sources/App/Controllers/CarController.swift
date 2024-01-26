//
//  CarController.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor
import RediStack

extension Car {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let cars = routes.grouped("cars")
            let secured = cars.grouped(SessionToken.asyncAuthenticator(), SessionToken.guardMiddleware())
            
            secured.get(use: index)
            
            secured.group("favorites") { favorites in
                favorites.get(use: getFavoriteCars)
            }
            
            let creat = secured.grouped("create")
            creat.post(use: create)
            
            secured.group(":car_id") { car in
                car.get(use: getCar)
                car.delete(use: delete)
                
                car.group("favorites") { favorites in
                    favorites.put(use: setFavoriteCar)
                }
            }
        }
        
        func getFavoriteCars(req: Request) async throws -> [Car.Simple] {
            let clientId = try req.jwt.verify(as: SessionToken.self).userId
            
            return try await ClientsFavoriteCars
                .query(on: req.db)
                .with(\.$car)
                .filter(\ClientsFavoriteCars.$client.$id == clientId)
                .all()
                .compactMap {
                    Car.Simple(car: $0.car)
                }
        }
        
//        func getNearbyCars(req: Request) async throws -> [Car.Simple] {
//            let coordinates = try req.content.decode(Coordinates.self)
//            let clientId = try req.jwt.verify(as: SessionToken.self).userId
//            
//            var redis = try req.redis.pool.requestConnection()
//
//                // Step 3: Query Nearby Car IDs from Redis
//                let nearbyCarKeys: [String] = try await redis.georadiusbymember(
//                    in: "car_coordinates",
//                    member: "client_\(clientId)",
//                    radius: 1_000,
//                    unit: .meters
//                )
//
//                // Step 4: Extract Car IDs from Redis Keys
//                let nearbyCarIDs = nearbyCarKeys.compactMap { key in
//                    guard let carIDString = key.split(separator: "_").dropFirst().first,
//                          let carID = Int(carIDString) else {
//                        return nil
//                    }
//                    return carID
//                }
//
//                // Step 5: Fetch Detailed Car Information from the Database
//                let detailedCars: [Car] = try await Car.query(on: req.db)
//                    .filter(\.$id ~~ nearbyCarIDs)
//                    .all()
//
//                // Step 6: Return Simplified Car Information
//                let simplifiedCars = detailedCars.map { Car.Simple(car: $0) }
//                return simplifiedCars
//        }
        
        func setFavoriteCar(req: Request) async throws -> HTTPStatus {
            let clientId = try req.jwt.verify(as: SessionToken.self).userId
            
            guard var carId = req.parameters.get("car_id"), var carId = Int(carId) else {
                throw Abort(.badRequest)
            }
            
            try await ClientsFavoriteCars(clientId: clientId, carId: carId).save(on: req.db)
                
            return .ok
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
        
        func create(req: Request) async throws -> Car {
            let newCarDto = try req.content
                .decode(Car.DTO.self)
            
            let car = Car(dto: newCarDto)
            
            try await car.save(on: req.db)
            
            guard let carId = car.id else {
                throw Abort(.internalServerError)
            }
            
            guard let car = try await Car
                .query(on: req.db)
                .with(\.$engine)
                .with(\.$owner)
                .filter(\Car.$id == carId)
                .first() else {
                throw Abort(.notFound)
            }
            
            return car
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
