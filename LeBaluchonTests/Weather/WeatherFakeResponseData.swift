//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 07/06/2023.
//

import Foundation

class WeatherFakeResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/weather")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    
    static let responseNotOk = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/weather")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    class WeatherError: Error {}
    static let error = WeatherError()
    
    static var nyWeatherCorrectData: Data {
        let bundle = Bundle(for: WeatherFakeResponseData.self)
        let url = bundle.url(forResource: "NYWeatherData", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let weatherIncorrectData = "error".data(using: .utf8)
}
