//
//  ConversionTests.swift
//  ConversionTests
//
//  Created by Lilian Grasset on 25/05/2023.
//

import XCTest
@testable import LeBaluchon

final class ConversionTests: XCTestCase {

    var dummyViewController: DummyConversionViewController!
    
    override func setUp() {
        super.setUp()
        
        dummyViewController = DummyConversionViewController()
        CurrencyService.shared.delegate = dummyViewController
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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
        let currencyService = CurrencyService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        currencyService.getCurrencyConverter { currencyConverter in
            XCTAssertNil(currencyConverter)
            let alertText = self.dummyViewController.alertText
            XCTAssertEqual(alertText, "Il y a eu une erreur lors de la réception des données.")
        }
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfNoData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        currencyService.getCurrencyConverter { currencyConverter in
            XCTAssertNil(currencyConverter)
            let alertText = self.dummyViewController.alertText
            XCTAssertEqual(alertText, "Il y a eu une erreur lors de la réception des données.")
        }
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfIncorrectResponse() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseNotOk, error: nil))
        
        currencyService.getCurrencyConverter { currencyConverter in
            XCTAssertNil(currencyConverter)
            let alertText = self.dummyViewController.alertText
            XCTAssertEqual(alertText, "Il y a eu une erreur côté serveur.")
        }
    }
    
    func testGetCurrencyConverterShouldPostFailedCallbackIfIncorectData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyIncorrectData, response: FakeResponseData.responseOk, error: nil))
        
        currencyService.getCurrencyConverter { currencyConverter in
            XCTAssertNil(currencyConverter)
            let alertText = self.dummyViewController.alertText
            XCTAssertEqual(alertText, "Il y a eu une erreur lors du décodage des données.")
        }
    }
    
    func testGetCurrencyConverterShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOk, error: nil))
        
        currencyService.getCurrencyConverter { currencyConverter in
            XCTAssertNotNil(currencyConverter)
            XCTAssertEqual(currencyConverter?.rates["AUD"], 1.640983)
        }
    }
    
    func testCurrencyConversionShouldSuccessBetweenAUDandUSD() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ currencyConverter in
            XCTAssertNotNil(currencyConverter)
            XCTAssertEqual(currencyConverter?.convert(from: "AUD", to: "USD", amount: 10), 6.535862955313979)
        }
    }
    
    func testCurrencyConversionShouldSuccessBetweenEURandUSD() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ currencyConverter in
            XCTAssertNotNil(currencyConverter)
            XCTAssertEqual(currencyConverter?.convert(from: "EUR", to: "USD", amount: 10), 10.72524)
        }
    }
    
    func testCurrencyConversionShouldFailBetweenUnlistedBaseandUSD() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ currencyConverter in
            XCTAssertNotNil(currencyConverter)
            XCTAssertEqual(currencyConverter?.convert(from: "XXX", to: "USD", amount: 10), 0)
        }
    }
    
    func testCurrencyConversionShouldFailBetweenAUDandUnlistedTarget() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ currencyConverter in
            XCTAssertNotNil(currencyConverter)
            XCTAssertEqual(currencyConverter?.convert(from: "AUD", to: "XXX", amount: 10), 0)
        }
    }
    
    func testCurrencyConversionShouldFailBetweenEURandUnlistedTarget() {
        let currencyService = CurrencyService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOk, error: nil))

        currencyService.getCurrencyConverter{ currencyConverter in
            XCTAssertNotNil(currencyConverter)
            XCTAssertEqual(currencyConverter?.convert(from: "EUR", to: "XXX", amount: 10), 0)
        }
    }
}

class DummyConversionViewController: CurrencyServiceDelegate {
    var alertText: String!

    func noData() {
        displayAlert("Il y a eu une erreur lors de la réception des données.")
    }
    
    func wrongStatusCode() {
        displayAlert("Il y a eu une erreur côté serveur.")
    }
    
    func decodingError() {
        displayAlert("Il y a eu une erreur lors du décodage des données.")
    }
    
    private func displayAlert(_ text: String) {
        alertText = text
    }
}
