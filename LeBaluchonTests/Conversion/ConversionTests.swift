//
//  ConversionTests.swift
//  ConversionTests
//
//  Created by Lilian Grasset on 25/05/2023.
//

import XCTest
@testable import LeBaluchon

final class ConversionTests: XCTestCase {

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
        let currencyService = CurrencyService(session: URLSessionFake(data: nil, response: nil, error: CurrencyFakeResponseData.error))
        
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.noData)
            }
        }
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfNoData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.noData)
            }
        }
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfIncorrectResponse() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseNotOk, error: nil))
        
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.wrongStatusCode)
            }
        }
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfIncorectData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyIncorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))
        
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(_):
                XCTFail("Error this should fail.")
            case .failure(let error):
                XCTAssertEqual(error, CurrencyServiceError.decodingError)
            }
        }
    }
    
    func testGetCurrencyConverterShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))
        
        currencyService.getCurrencyConverter { result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.rates["AUD"], 1.640983)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
        }
    }
    
    func testCurrencyConversionShouldSuccessBetweenAUDandUSD() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "AUD", to: "USD", amount: 10), 6.535862955313979)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
        }
    }
    
    func testCurrencyConversionShouldSuccessBetweenEURandUSD() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "EUR", to: "USD", amount: 10), 10.72524)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
        }
    }
    
    func testCurrencyConversionShouldFailBetweenUnlistedBaseandUSD() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "XXX", to: "USD", amount: 10), 0)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
        }
    }
    
    func testCurrencyConversionShouldFailBetweenAUDandUnlistedTarget() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "AUD", to: "XXX", amount: 10), 0)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
        }
    }
    
    func testCurrencyConversionShouldFailBetweenEURandUnlistedTarget() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ result in
            switch result {
            case .success(let currencyConverter):
                XCTAssertEqual(currencyConverter.convert(from: "EUR", to: "XXX", amount: 10), 0)
            case .failure(let error):
                XCTFail("Error this should success: \(error.self) - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Test getCurrencyConverter with async await
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfError() {
        let currencyService = CurrencyService(session: URLSessionFake(data: nil, response: nil, error: CurrencyFakeResponseData.error))
        
        Task.init {
            do {
                let converter = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.noData {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfNoData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        Task.init {
            do {
                let converter = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.noData {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfIncorrectResponse() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseNotOk, error: nil))
        
        Task.init {
            do {
                let converter = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.wrongStatusCode {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldPostFailedCallbackIfIncorectData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyIncorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))
        
        Task.init {
            do {
                let converter = try await currencyService.getCurrencyConverter()
                XCTFail("Error this should fail.")
            } catch CurrencyServiceError.decodingError {
                XCTAssert(true)
            }
        }
    }
    
    func testGetCurrencyConverterAsyncAwaitShouldSuccess() {
        let currencyService = CurrencyService(session: URLSessionFake(data: CurrencyFakeResponseData.currencyCorrectData, response: CurrencyFakeResponseData.responseOk, error: nil))
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
