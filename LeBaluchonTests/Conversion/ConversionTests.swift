//
//  ConversionTests.swift
//  ConversionTests
//
//  Created by Lilian Grasset on 25/05/2023.
//

import XCTest
@testable import LeBaluchon

final class ConversionTests: XCTestCase {

    let baseURL = "http://data.fixer.io"
    
    // MARK: Testing CurrencySymbols class
    func testGettingCurrencySymbolIndex() {
        // Given
        let symbol = "AUD"
        
        // When
        let index = CurrencySymbols.indexOf(symbol)
        
        // Then
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 7)
    }

    func testGettingNextIndexOfSymbol() {
        let index = 7
        
        let nextIndex = CurrencySymbols.nextIndex(after: index)
        
        XCTAssertEqual(nextIndex, 8)
    }
    
    func testGettingNextIndexOfLastSymbol() {
        let index = 169
        
        let nextIndex = CurrencySymbols.nextIndex(after: index)
        
        XCTAssertEqual(nextIndex, 168)
    }
    
    // MARK: Testing CurrencyService class
    func testGetCurrencyConverterShouldPostFailedCallbackIfError() {
        let testPath = "/test/getCurrencyConverterShouldPostFailedCallbackIfError"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: CurrencyFakeResponseData.error)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.noData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfNoData() {
        let testPath = "/test/getCurrencyConverterShouldPostFailedCallbackIfNoData"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.noData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfIncorrectResponse() {
        let testPath = "/test/getCurrencyConverterShouldPostFailedCallbackIfIncorrectResponse"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseNotOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.wrongStatusCode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfIncorectData() {
        let testPath = "/test/getCurrencyConverterShouldPostFailedCallbackIfIncorectData"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyIncorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.decodingError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testGetCurrencyConverterShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let testPath = "/test/getCurrencyConverterShouldPostSuccessCallbackIfNoErrorAndCorrectData"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.rates["AUD"], 1.640983)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testCurrencyConversionShouldSuccessBetweenAUDandUSD() {
        let testPath = "/test/currencyConversionShouldSuccessBetweenAUDandUSD"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "AUD", to: "USD", amount: 10), 6.535862955313979)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testCurrencyConversionShouldSuccessBetweenEURandUSD() {
        let testPath = "/test/currencyConversionShouldSuccessBetweenEURandUSD"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "EUR", to: "USD", amount: 10), 10.72524)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testCurrencyConversionShouldFailBetweenUnlistedBaseandUSD() {
        let testPath = "/test/currencyConversionShouldFailBetweenUnlistedBaseandUSD"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "XXX", to: "USD", amount: 10), 0)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testCurrencyConversionShouldFailBetweenAUDandUnlistedTarget() {
        let testPath = "/test/currencyConversionShouldFailBetweenAUDandUnlistedTarget"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "AUD", to: "XXX", amount: 10), 0)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testCurrencyConversionShouldFailBetweenEURandUnlistedTarget() {
        let testPath = "/test/currencyConversionShouldFailBetweenEURandUnlistedTarget"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "EUR", to: "XXX", amount: 10), 0)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    // MARK: Test getCurrencyConverter with async await
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfError() {
        let testPath = "/test/getCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfError"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: CurrencyFakeResponseData.error)
        
        Task.init {
            do {
                let _ = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.noData {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfNoData() {
        let testPath = "/test/getCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfNoData"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: nil)
        
        Task.init {
            do {
                let _ = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.noData {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfIncorrectResponse() {
        let testPath = "/test/getCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfIncorrectResponse"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseNotOk, error: nil)
        
        Task.init {
            do {
                let _ = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.wrongStatusCode {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfIncorectData() {
        let testPath = "/test/getCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfIncorectData"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyIncorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        Task.init {
            do {
                let _ = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.decodingError {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldSuccess() {
        let testPath = "/test/getCurrencyConverterAsyncAwaitShouldSuccess"
        let testURL = URL(string: baseURL + testPath)!
        let currencyService = CurrencyService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil)
        
        Task.init {
            do {
                let converter = try await currencyService.getCurrencyConverter()
                XCTAssertNotNil(converter)
            } catch {
                XCTFail("An error occured")
            }
        }
    }
}
