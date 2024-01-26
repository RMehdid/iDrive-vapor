//
//  File.swift
//  
//
//  Created by Samy Mehdid on 1/1/2024.
//

import Vapor
import WebSocketKit
import Redis

class Websocket {
    struct Controller: RouteCollection {
        func boot(routes: RoutesBuilder) throws {
            let carSecured = routes.grouped(CarToken.asyncAuthenticator(), CarToken.guardMiddleware())
            carSecured.webSocket("ws", "setCoordinates", onUpgrade: setCoordinates)
            carSecured.webSocket("ws", "setFuelLevel", onUpgrade: setFuelLevel)
            
            let userSecured = routes.grouped(SessionToken.asyncAuthenticator(), SessionToken.guardMiddleware())
            userSecured.webSocket("ws", ":car_id", "getCoordinates", onUpgrade: getCoordinates)
            userSecured.webSocket("ws", ":car_id", "getFuelLevel", onUpgrade: getFuelLevel)
        }

        func setCoordinates(req: Request, ws: WebSocket) {
            ws.onText { ws, text in
                
                guard let carId = req.parameters.get("car_id") else {
                    ws.send("no car to set coordinates to")
                    return
                }
                
                guard let data = text.data(using: .utf8),
                      let coordinates = try? JSONDecoder().decode(Coordinates.self, from: data) else {
                    ws.send("could not decode data")
                    return
                }
                
                // Store the coordinates in Redis with the carId as part of the key
                let key = RedisKey("car:\(carId):coordinates")
                
                let _ = req.redis.set(key, toJSON: coordinates)
                
                // Send a confirmation message back to the client
                ws.send("Coordinates for car \(carId) saved successfully")
            }

            // Handle WebSocket disconnect event
            ws.onClose.whenComplete { _ in
                print("WebSocket disconnected")
            }
        }
        
        func getCoordinates(req: Request, ws: WebSocket) {
            guard let carId = req.parameters.get("car_id") else {
                ws.send("no car to get coordinates of")
                return
            }
            
            // Use a timer to periodically send data to the client
            let timer = req.eventLoop.scheduleRepeatedTask(initialDelay: .zero, delay: .seconds(10)) { task in
                // Retrieve the coordinates from Redis using the carId
                let key = RedisKey("car:\(carId):coordinates")
                // Wait for the EventLoopFuture to complete
                req.redis.get(key, asJSON: Coordinates.self).whenComplete { result in
                    switch result {
                    case .success(let storedCoordinates):
                        guard let storedCoordinates = storedCoordinates else {
                            ws.send("no coordinates found")
                            return
                        }
                        
                        do {
                            // Encode the Coordinates object as JSON
                            let jsonData = try JSONEncoder().encode(storedCoordinates)
                            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                                ws.send("error converting data to string")
                                return
                            }
                            
                            // Send the JSON string to the client
                            ws.send(jsonString)
                        } catch {
                            ws.send("error encoding data: \(error)")
                        }
                        
                    case .failure(let error):
                        ws.send("error retrieving data: \(error)")
                    }
                }
            }
            
            // Handle WebSocket disconnect event
            ws.onClose.whenComplete { _ in
                print("WebSocket disconnected")
                timer.cancel()
            }
        }
        
        func setFuelLevel(req: Request, ws: WebSocket) {
            ws.onText { ws, text in
                
                guard let carId = req.parameters.get("car_id") else {
                    ws.send("no car to set fuel level to")
                    return
                }
                
                // Store the coordinates in Redis with the carId as part of the key
                let key = RedisKey("car_\(carId)_fuel_level")
                
                let _ = req.redis.set(key, to: text)
                
                // Send a confirmation message back to the client
                ws.send("Fuel Level for car \(carId) saved successfully")
            }

            // Handle WebSocket disconnect event
            ws.onClose.whenComplete { _ in
                print("WebSocket disconnected")
            }
        }
        
        func getFuelLevel(req: Request, ws: WebSocket) {
            guard let carId = req.parameters.get("car_id") else {
                ws.send("no car to get fuel level of")
                return
            }
            
            // Use a timer to periodically send data to the client
            let timer = req.eventLoop.scheduleRepeatedTask(initialDelay: .zero, delay: .seconds(60)) { task in
                
                // Retrieve the coordinates from Redis using the carId
                let key = RedisKey("car_\(carId)_fuel_level")
                
                // Send the fuel level to the client
                req.redis.get(key, as: Int.self).whenComplete { result in
                    switch result {
                    case .success(let level):
                        if let level = level {
                            ws.send("\(level)")
                        } else {
                            ws.send("no fuel level found")
                        }
                    case .failure(let error):
                        ws.send("error retrieving fuel level: \(error)")
                    }
                }
            }
            
            // Handle WebSocket disconnect event
            ws.onClose.whenComplete { _ in
                print("WebSocket disconnected")
                timer.cancel()
            }
        }
    }
}
