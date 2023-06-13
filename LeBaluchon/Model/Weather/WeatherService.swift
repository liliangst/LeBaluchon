//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 07/06/2023.
//

import Foundation
import CoreLocation

enum WeatherServiceError: Error {
    case noData, wrongStatusCode, decodingError
}

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    
    private let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    private var session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    
    init(session: URLSession) {
        self.session = session
    }
    
    @available(*, renamed: "fetchWeatherData(at:)")
    func fetchWeatherData(at location: WeatherLocation, callback: @escaping (Result<WeatherData, WeatherServiceError>) -> Void) {
        var url = weatherURL
        
        url.append(queryItems: [URLQueryItem(name: "lat", value: String(location.location.coordinate.latitude)),
                                URLQueryItem(name: "lon", value: String(location.location.coordinate.longitude)),
                                 URLQueryItem(name: "appid", value: Constants.weatherApiKey),
                                 URLQueryItem(name: "units", value: "metric")])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(.failure(.noData))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(.wrongStatusCode))
                    return
                }
                guard let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                    callback(.failure(.decodingError))
                    return
                }
                callback(.success(weatherData))
            }
        }
        task?.resume()
    }
    
    func fetchWeatherData(at location: WeatherLocation) async throws -> WeatherData {
        return try await withCheckedThrowingContinuation { continuation in
            fetchWeatherData(at: location) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func fetchBothWeatherData(at firstLocation: WeatherLocation, and secondLocation: WeatherLocation, callback: @escaping (Result<[WeatherData], WeatherServiceError>) -> Void) {
        Task.init {
            do {
                let firstWeather = try await fetchWeatherData(at: firstLocation)
                let secondWeather = try await fetchWeatherData(at: secondLocation)
                callback(.success([firstWeather, secondWeather]))
            } catch let error as WeatherServiceError {
                callback(.failure(error))
            }
        }
    }
    
}
