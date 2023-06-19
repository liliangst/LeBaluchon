//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 16/06/2023.
//

import Foundation

enum TranslationServiceError: Error {
    case noData, wrongStatusCode, decodingError
}

class TranslationService {
    static let shared = TranslationService()
    private init() {}
    
    typealias LangISOCode = String
    
    private let translationURL = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    private var session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchTranslationData(source: LangISOCode, target: LangISOCode, text: String, callback: @escaping (Result<TranslationData, TranslationServiceError>) -> Void) {
        var url = translationURL
        
        url.append(queryItems: [URLQueryItem(name: "key", value: Constants.translationApiKey)])
        
        let json: [String: Any] = ["q": text,
                                   "source": source,
                                   "target": target,
                                   "format": "text"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        
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
                guard let translationData = try? JSONDecoder().decode(TranslationData.self, from: data) else {
                    callback(.failure(.decodingError))
                    return
                }
                callback(.success(translationData))
            }
        }
        task?.resume()
    }
}
