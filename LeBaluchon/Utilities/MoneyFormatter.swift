//
//  MoneyFormatter.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 01/06/2023.
//

import Foundation

class MoneyFormatter {
    
    static func format(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        let formatedValue = formatter.string(from: number as NSNumber)

        return formatedValue!
    }
}
