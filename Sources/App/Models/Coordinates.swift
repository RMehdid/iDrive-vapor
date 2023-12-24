//
//  File.swift
//  
//
//  Created by Samy Mehdid on 24/12/2023.
//

import Foundation

final class Coordinates: Codable {
    
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
