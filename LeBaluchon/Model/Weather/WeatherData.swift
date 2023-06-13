//
//  WeatherData.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 07/06/2023.
//

import Foundation

struct WeatherData: Decodable {
    private var weather: [Weather]
    private var main: Main

    var name: String
    var temperature: Int {
        Int(self.main.temp.rounded(.toNearestOrAwayFromZero))
    }
    var icon: String {
        WeatherIcon.imageName(for: self.weather.first!.icon)
    }
}

private struct Weather: Decodable {
    var icon: String
}
private struct Main: Decodable {
    var temp: Double
}


