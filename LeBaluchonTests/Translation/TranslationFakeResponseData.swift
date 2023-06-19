//
//  TranslationFakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 16/06/2023.
//

import Foundation

class TranslationFakeResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://translation.googleapis.com/language/translate/v2")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    
    static let responseNotOk = HTTPURLResponse(url: URL(string: "https://translation.googleapis.com/language/translate/v2")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    class TranslationError: Error {}
    static let error = TranslationError()
    
    static var translationCorrectData: Data {
        let bundle = Bundle(for: TranslationFakeResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let translationIncorrectData = "error".data(using: .utf8)
}

