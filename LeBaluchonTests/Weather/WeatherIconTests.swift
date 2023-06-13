//
//  WeatherIconTests.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 09/06/2023.
//

import XCTest
@testable import LeBaluchon

final class WeatherIconTests: XCTestCase {

    func testEveryIconOutputShouldSuccess() {
        XCTAssertEqual(WeatherIcon.imageName(for: "01d"), "sun.max")
        XCTAssertEqual(WeatherIcon.imageName(for: "01n"), "sun.max")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "02d"), "cloud.sun")
        XCTAssertEqual(WeatherIcon.imageName(for: "02n"), "cloud.sun")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "03d"), "cloud")
        XCTAssertEqual(WeatherIcon.imageName(for: "03n"), "cloud")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "04d"), "cloud.fill")
        XCTAssertEqual(WeatherIcon.imageName(for: "04n"), "cloud.fill")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "09d"), "cloud.drizzle")
        XCTAssertEqual(WeatherIcon.imageName(for: "09n"), "cloud.drizzle")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "10d"), "cloud.sun.rain")
        XCTAssertEqual(WeatherIcon.imageName(for: "10n"), "cloud.sun.rain")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "11d"), "cloud.bolt")
        XCTAssertEqual(WeatherIcon.imageName(for: "11n"), "cloud.bolt")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "13d"), "snowflake")
        XCTAssertEqual(WeatherIcon.imageName(for: "13n"), "snowflake")
        
        XCTAssertEqual(WeatherIcon.imageName(for: "50d"), "cloud.fog")
        XCTAssertEqual(WeatherIcon.imageName(for: "50n"), "cloud.fog")
        
        XCTAssertEqual(WeatherIcon.imageName(for: ""), "cloud")
    }

}
