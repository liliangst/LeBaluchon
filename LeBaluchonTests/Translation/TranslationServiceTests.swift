//
//  TranslationServiceTests.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 16/06/2023.
//

import XCTest
@testable import LeBaluchon

final class TranslationServiceTests: XCTestCase {
    
    let testText = "This is a translation test"
    
    let baseURL = "https://translation.googleapis.com"
    
    func testFetchTranslationDataShouldPostFailedCallbackIfError() {
        let testPath = "/test/fetchTranslationDataShouldPostFailedCallbackIfError"
        let testURL = URL(string: baseURL + testPath)!
        let translationService = TranslationService(
            session: URLSessionFakeBuilder().session, url: testURL)
        
        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: TranslationFakeResponseData.error)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translationService.fetchTranslationData(source: "en", target: "fr", text: testText) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchTranslationDataShouldPostFailedCallbackIfNoData() {
        let testPath = "/test/fetchTranslationDataShouldPostFailedCallbackIfNoData"
        let testURL = URL(string: baseURL + testPath)!
        let translationService = TranslationService(
            session: URLSessionFakeBuilder().session, url: testURL)
        
        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translationService.fetchTranslationData(source: "en", target: "fr", text: testText) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchTranslationDataShouldPostFailedCallbackIfIncorrectResponse() {
        let testPath = "/test/fetchTranslationDataShouldPostFailedCallbackIfIncorrectResponse"
        let testURL = URL(string: baseURL + testPath)!
        let translationService = TranslationService(
            session: URLSessionFakeBuilder().session, url: testURL)
        
        MockURLProtocol.mockURLs[testPath] = (data: TranslationFakeResponseData.translationCorrectData, response: TranslationFakeResponseData.responseNotOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translationService.fetchTranslationData(source: "en", target: "fr", text: testText) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .wrongStatusCode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchTranslationDataShouldPostFailedCallbackIfIncorectData() {
        let testPath = "/test/fetchTranslationDataShouldPostFailedCallbackIfIncorectData"
        let testURL = URL(string: baseURL + testPath)!
        let translationService = TranslationService(
            session: URLSessionFakeBuilder().session, url: testURL)
        
        MockURLProtocol.mockURLs[testPath] = (data: TranslationFakeResponseData.translationIncorrectData, response: TranslationFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translationService.fetchTranslationData(source: "en", target: "fr", text: testText) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchTranslationDataShouldSuccess() {
        let testPath = "/test/fetchTranslationDataShouldSuccess"
        let testURL = URL(string: baseURL + testPath)!
        let translationService = TranslationService(
            session: URLSessionFakeBuilder().session, url: testURL)
        
        MockURLProtocol.mockURLs[testPath] = (data: TranslationFakeResponseData.translationCorrectData, response: TranslationFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translationService.fetchTranslationData(source: "en", target: "fr", text: testText) { result in
            switch result {
            case .success(let translationData):
                XCTAssertEqual(translationData.text, "Ceci est un test de traduction")
            case .failure(let error):
                XCTFail("Fetching should success but there is an error: \(error.self), \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
