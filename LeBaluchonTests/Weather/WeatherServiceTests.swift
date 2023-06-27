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
    
    let baseURL = "https://api.openweathermap.org"
    
    // MARK: Testing WeatherService class
    func testFetchWeatherDataShouldPostFailedCallbackIfError() {
        let testPath = "/test/fetchWeatherDataShouldPostFailedCallbackIfError"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: WeatherFakeResponseData.error)
        
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
        wait(for: [expectation])
    }
    
    func testFetchWeatherDataShouldPostFailedCallbackIfNoData() {
        let testPath = "/test/fetchWeatherDataShouldPostFailedCallbackIfNoData"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: nil)
        
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
        wait(for: [expectation])
    }
    
    func testFetchWeatherDataShouldPostFailedCallbackIfIncorrectResponse() {
        let testPath = "/test/fetchWeatherDataShouldPostFailedCallbackIfIncorrectResponse"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseNotOk, error: nil)
        
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
        wait(for: [expectation])
    }
    
    func testFetchWeatherDataShouldPostFailedCallbackIfIncorectData() {
        let testPath = "/test/fetchWeatherDataShouldPostFailedCallbackIfIncorectData"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: WeatherFakeResponseData.weatherIncorrectData, response: WeatherFakeResponseData.responseOk, error: nil)
        
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
        wait(for: [expectation])
    }
    
    func testFetchWeatherDataShouldSuccess() {
        let testPath = "/test/fetchWeatherDataShouldSuccess"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseOk, error: nil)
        
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
    
    func testFetchWeatherDataAsyncShouldSuccess() {
        let testPath = "/test/fetchWeatherDataAsyncShouldSuccess"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseOk, error: nil)
        
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
        let testPath = "/test/fetchBothWeatherDataShouldSuccess"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: WeatherFakeResponseData.nyWeatherCorrectData, response: WeatherFakeResponseData.responseOk, error: nil)
        
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
            case .failure(let error):
                XCTFail("Fetching both weather data should success but there is an error: \(error.self), \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchBothWeatherDataShouldFail() {
        let testPath = "/test/fetchBothWeatherDataShouldFail"
        let testURL = URL(string: baseURL + testPath)!
        let weatherService = WeatherService(
            session: URLSessionFakeBuilder().session, url: testURL)

        MockURLProtocol.mockURLs[testPath] = (data: nil, response: nil, error: WeatherFakeResponseData.error)
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.fetchBothWeatherData(at: .newYork, and: .newYork) { result in
            switch result {
            case .success(_):
                XCTFail("Fetching both weather data should fail but succeeded.")
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
