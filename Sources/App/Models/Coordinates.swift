//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Fluent
import Vapor

final class Coordinates: Content {
    
    var latitude: Double
    
    var longitude: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}
