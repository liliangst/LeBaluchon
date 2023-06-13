//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 31/05/2023.
//

import Foundation

enum CurrencyServiceError: Error {
    case noData, wrongStatusCode, decodingError
}

class CurrencyService {
    static var shared = CurrencyService()
    private init() {}
    
    private let currencyURL = URL(string: "http://data.fixer.io/api/latest")!
    private var session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getCurrencyConverter(callback: @escaping (Result<CurrencyConverter, CurrencyServiceError>) -> Void) {
        var url = currencyURL
        url.append(queryItems: [URLQueryItem(name: "access_key", value: Constants.currencyApiKey)])
        
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
                guard let converter = try? JSONDecoder().decode(CurrencyConverter.self, from: data) else {
                    callback(.failure(.decodingError))
                    return
                }
                callback(.success(converter))
            }
        }
        task?.resume()
    }
    
    func getCurrencyConverter() async throws -> CurrencyConverter {
        var url = currencyURL
        url.append(queryItems: [URLQueryItem(name: "access_key", value: Constants.currencyApiKey)])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        task?.cancel()
        return try await withCheckedThrowingContinuation { continuation in
            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data1 = data, error == nil else {
                        continuation.resume(throwing: CurrencyServiceError.noData)
                        return
                    }
                    guard let response1 = response as? HTTPURLResponse, response1.statusCode == 200 else {
                        continuation.resume(throwing: CurrencyServiceError.wrongStatusCode)
                        return
                    }
                    guard let converter = try? JSONDecoder().decode(CurrencyConverter.self, from: data1) else {
                        continuation.resume(throwing: CurrencyServiceError.decodingError)
                        return
                    }
                    continuation.resume(returning: converter)
                }
            }
            task?.resume()
        }
    }
}
