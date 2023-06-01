//
//  MoneyFormatterTests.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 01/06/2023.
//

import XCTest
@testable import LeBaluchon

final class MoneyFormatterTests: XCTestCase {

    func testFormatting() {
        // Given
        let number = 15.95123
        
        // When
        let money = MoneyFormatter.format(number)
        
        // Then
        XCTAssertEqual(money, "15.95")
    }

}
