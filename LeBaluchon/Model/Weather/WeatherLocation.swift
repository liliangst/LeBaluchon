//
//  WeatherLocation.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 12/06/2023.
//

import Foundation
import CoreLocation

enum WeatherLocation {
    case newYork
    case local
    
    typealias RawValue = CLLocation
    
    var location: CLLocation {
        switch self {
        case .newYork: return CLLocation(latitude: 40.7127281, longitude: -74.0060152)
        case .local: return CLLocation(latitude: 45.042111873956074, longitude: 3.881545746842203)
        }
    }
    
}
