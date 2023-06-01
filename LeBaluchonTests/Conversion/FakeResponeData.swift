//
//  FakeResponeData.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 01/06/2023.
//

import Foundation

class FakeResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "http://data.fixer.io/api/")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    
    static let responseNotOk = HTTPURLResponse(url: URL(string: "http://data.fixer.io/api/")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    class CurrencyError: Error {}
    static let error = CurrencyError()
    
    static var currencyCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Rates", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let currencyIncorrectData = "error".data(using: .utf8)
}
