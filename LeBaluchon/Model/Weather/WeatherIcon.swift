//
//  WeatherIcon.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 08/06/2023.
//

import Foundation

struct WeatherIcon {
    static func imageName(for icon: String) -> String {
        switch icon {
        case "01d", "01n":
            return "sun.max"
        case "02d", "02n":
            return "cloud.sun"
        case "03d", "03n":
            return "cloud"
        case "04d", "04n":
            return "cloud.fill"
        case "09d", "09n":
            return "cloud.drizzle"
        case "10d", "10n":
            return "cloud.sun.rain"
        case "11d", "11n":
            return "cloud.bolt"
        case "13d", "13n":
            return "snowflake"
        case "50d", "50n":
            return "cloud.fog"
        default: break
        }
        return "cloud"
    }
}
