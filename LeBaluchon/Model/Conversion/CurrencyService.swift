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
    
    private var currencyURL = URL(string: "http://data.fixer.io/api/latest")!
    private var session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.currencyURL = url
    }
    
    func getCurrencyConverter(callback: @escaping (Result<CurrencyConverter, CurrencyServiceError>) -> Void) {
        var url = currencyURL
        if #available(iOS 16.0, *) {
            url.append(queryItems: [URLQueryItem(name: "access_key", value: Constants.currencyApiKey)])
        } else {
            url = URL(string: url.absoluteString +
                      "?access_key=\(Constants.currencyApiKey)"
            )!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, !data.isEmpty, error == nil else {
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
        if #available(iOS 16.0, *) {
            url.append(queryItems: [URLQueryItem(name: "access_key", value: Constants.currencyApiKey)])
        } else {
            url.appendPathComponent("?access_key=\(Constants.currencyApiKey)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        task?.cancel()
        return try await withCheckedThrowingContinuation { continuation in
            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        continuation.resume(throwing: CurrencyServiceError.noData)
                        return
                    }
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        continuation.resume(throwing: CurrencyServiceError.wrongStatusCode)
                        return
                    }
                    guard let converter = try? JSONDecoder().decode(CurrencyConverter.self, from: data) else {
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
