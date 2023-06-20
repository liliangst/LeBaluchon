//
//  WeatherServiceTests.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 07/06/2023.
//

import XCTest
@testable import LeBaluchon
import CoreLocation

final class WeatherServiceTests: XCTestCase {
    
    // MARK: Testing WeatherService class
    func testFetchWeatherDataShouldPostFailedCallbackIfError() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: WeatherFakeResponseData.error).session)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchWeatherData(at: .newYork) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            }
            expectation.fulfill()
        }
    }
    
    func testFetchWeatherDataShouldPostFailedCallbackIfNoData() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: nil).session)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchWeatherData(at: .local) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            }
            expectation.fulfill()
        }
    }
    
    func testFetchWeatherDataShouldPostFailedCallbackIfIncorrectResponse() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseNotOk, error: nil).session)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchWeatherData(at: .newYork) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .wrongStatusCode)
            }
            expectation.fulfill()
        }
    }
    
    func testFetchWeatherDataShouldPostFailedCallbackIfIncorectData() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: WeatherFakeResponseData.weatherIncorrectData, response: WeatherFakeResponseData.responseOk, error: nil).session)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchWeatherData(at: .local)  { result in
            switch result {
            case .success(_):
                XCTFail("Fetching should fail")
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
            }
            expectation.fulfill()
        }
    }
    
    func testfetchWeatherDataShouldSuccess() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseOk, error: nil).session)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchWeatherData(at: .newYork) { result in
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.name, "New York")
                XCTAssertEqual(weatherData.temperature, 14)
                XCTAssertEqual(weatherData.icon, "cloud.fog")
            case .failure(let error):
                XCTFail("Fetching should success but there is an error: \(error.self), \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
    }
    
    func testfetchWeatherDataAsyncShouldSuccess() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseOk, error: nil).session)
        
        Task.init {
            do {
                let weatherData = try await weatherService.fetchWeatherData(at: .newYork)
                XCTAssertEqual(weatherData.name, "New York")
                XCTAssertEqual(weatherData.temperature, 14)
                XCTAssertEqual(weatherData.icon, "cloud.fog")
            } catch {
                XCTFail("Fetching asynchronously should success but there is an error: \(error.self), \(error.localizedDescription)")
            }
        }
    }
    
    func testFetchBothWeatherDataShouldSuccess() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseOk, error: nil).session)

        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchBothWeatherData(at: .newYork, and: .newYork) { result in
            switch result {
            case .success(let weatherDataList):
                let nyFirstWeatherData = weatherDataList[0]
                XCTAssertEqual(nyFirstWeatherData.name, "New York")
                XCTAssertEqual(nyFirstWeatherData.temperature, 14)
                XCTAssertEqual(nyFirstWeatherData.icon, "cloud.fog")
                
                let nySecondWeatherData = weatherDataList[1]
                XCTAssertEqual(nySecondWeatherData.name, "New York")
                XCTAssertEqual(nySecondWeatherData.temperature, 14)
                XCTAssertEqual(nySecondWeatherData.icon, "cloud.fog")
                
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetching both weather data should success but there is an error: \(error.self), \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
    }
    
    func testFetchBothWeatherDataShouldFail() {
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: WeatherFakeResponseData.error).session)

        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchBothWeatherData(at: .newYork, and: .newYork) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching both weather data should fail but succeeded.")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, .noData)
                expectation.fulfill()
            }
        }
    }
}
