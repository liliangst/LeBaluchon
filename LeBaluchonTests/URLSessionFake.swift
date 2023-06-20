//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 01/06/2023.
//

import Foundation

class URLSessionFake {
    let session: URLSession
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        session = URLSession(configuration: configuration)
        
        MockURLProtocol.requestHandler = { request in
            if let error {
                throw error
            }
            return (response, data)
        }
    }
}

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (URLResponse?, Data?))?
    
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
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
    
}
