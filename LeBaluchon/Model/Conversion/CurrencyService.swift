//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 31/05/2023.
//

import Foundation

protocol CurrencyServiceDelegate: AnyObject {
    func noData()
    func wrongStatusCode()
    func decodingError()
}

class CurrencyService {
    static var shared = CurrencyService()
    private init() {}
    
    weak var delegate: CurrencyServiceDelegate?
    
    enum CurrencyServiceError: Error {
        case noData, wrongStatusCode, decodeError
    }
    
    private static let currencyURL = URL(string: "http://data.fixer.io/api/latest")!
    private var session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    
    init(session: URLSession) {
        self.session = session
    }
        
    func getCurrencyConverter(callback: @escaping (CurrencyConverter?) -> Void) {
        var url = CurrencyService.currencyURL
        url.append(queryItems: [URLQueryItem(name: "access_key", value: "0993c95f421e6a935a2960218864470a")])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.delegate?.noData()
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.wrongStatusCode()
                return
            }
            guard let converter = try? JSONDecoder().decode(CurrencyConverter.self, from: data) else {
                self.delegate?.decodingError()
                return
            }
            callback(converter)
        }
        task?.resume()
    }
}
