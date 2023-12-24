//
//  CarController.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

struct CarController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cars = routes.grouped("cars")
        cars.get(use: index)
        cars.post(use: create)
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Car]> {
        return Car.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let car = try req.content.decode(Car.self)
        return car.save(on: req.db).transform(to: .ok)
    }
}
