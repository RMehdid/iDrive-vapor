//
//  File.swift
//  
//
//  Created by Samy Mehdid on 31/12/2023.
//

import Fluent
import Vapor

extension RentalTransaction {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let transactions = routes.grouped("rental_transactions")
            let secured = transactions.grouped(SessionToken.asyncAuthenticator(), SessionToken.guardMiddleware())
            
            secured.get(use: getTransactions)
            secured.post(use: create)
            
            secured.group(":transaction_id") { transaction in
                transaction.group("start") { start in
                    start.put(use: updateStartDate)
                }
            }
            
            secured.group(":transaction_id") { transaction in
                transaction.group("end") { end in
                    end.put(use: updateEndDate)
                }
            }
            
            secured.group(":transaction_id") { transaction in
                transaction.group("price") { price in
                    price.put(use: updatePrice)
                }
            }
        }
        
        func getTransactions(req: Request) async throws -> [RentalTransaction] {
            if let carId = try? req.query.get(Int.self, at: "car_id") {
                return try await RentalTransaction
                    .query(on: req.db)
                    .with(\.$car)
                    .with(\.$client)
                    .filter(\RentalTransaction.$car.$id == carId)
                    .all()
            } else if let clientId = try? req.query.get(Int.self, at: "client_id") {
                return try await RentalTransaction
                    .query(on: req.db)
                    .with(\.$car)
                    .with(\.$client)
                    .filter(\RentalTransaction.$client.$id == clientId)
                    .all()
            } else {
                throw Abort(.badRequest, reason: "Either car_id or client_id must be provided.")
            }
        }
        
        func create(req: Request) async throws -> HTTPStatus {
            let transactionDto = try req.content
                .decode(RentalTransaction.DTO.self)
            
            try await RentalTransaction(dto: transactionDto)
                .save(on: req.db)
            
            return .ok
        }
        
        func updatePrice(req: Request) async throws -> HTTPStatus {
            
            guard let transactionId = UUID(req.parameters.get("transaction_id") ?? "") else {
                throw Abort(.notFound, reason: "rental transaction not found")
            }
            
            let price = try req.content.decode(Int.self)
            
            try await RentalTransaction.find(transactionId, on: req.db)
                .flatMap {
                    $0.totalCost = price
                    return $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func updateStartDate(req: Request) async throws -> HTTPStatus {
            guard let transactionId = UUID(req.parameters.get("transaction_id") ?? "") else {
                throw Abort(.notFound, reason: "rental transaction not found")
            }
            
            let startDate = try req.content.decode(Date.self)
            
            try await RentalTransaction.find(transactionId, on: req.db)
                .flatMap {
                    $0.startDate = startDate
                    return $0.update(on: req.db)
                }
            
            return .ok
        }
        
        func updateEndDate(req: Request) async throws -> HTTPStatus {
            guard let transactionId = UUID(req.parameters.get("transaction_id") ?? "") else {
                throw Abort(.notFound, reason: "rental transaction not found")
            }
            
            let endDate = try req.content.decode(Date.self)
            
            try await RentalTransaction.find(transactionId, on: req.db)
                .flatMap {
                    $0.endDate = endDate
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
