//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 01/06/2023.
//

import Foundation

class URLSessionFakeBuilder {
    let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        session = URLSession(configuration: configuration)
    }
}

class MockURLProtocol: URLProtocol {
    
    static var mockURLs = [String: (data: Data?, response: HTTPURLResponse?, error: Error?)]()
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let (data, response, error) = MockURLProtocol.mockURLs[url.relativePath] {

                if let data = data {
                    client?.urlProtocol(self, didLoad: data)
                }
                
                if let response = response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }

                if let error = error {
                    client?.urlProtocol(self, didFailWithError: error)
                }
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
    
}
