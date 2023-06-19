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
    
    func testFetchTranslationDataShouldPostFailedCallbackIfError() {
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: nil, error: TranslationFakeResponseData.error))
        
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
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testFetchTranslationDataShouldPostFailedCallbackIfNoData() {
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        
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
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testFetchTranslationDataShouldPostFailedCallbackIfIncorrectResponse() {
        let translationService = TranslationService(
            session: URLSessionFake(data: TranslationFakeResponseData.translationCorrectData, response: TranslationFakeResponseData.responseNotOk, error: nil))
        
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
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testFetchTranslationDataShouldPostFailedCallbackIfIncorectData() {
        let translationService = TranslationService(
            session: URLSessionFake(data: TranslationFakeResponseData.translationIncorrectData, response: TranslationFakeResponseData.responseOk, error: nil))
        
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
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testfetchTranslationDataShouldSuccess() {
        let translationService = TranslationService(
            session: URLSessionFake(data: TranslationFakeResponseData.translationCorrectData, response: TranslationFakeResponseData.responseOk, error: nil))
        
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
        wait(for: [expectation], timeout: 0.01)
    }
}
