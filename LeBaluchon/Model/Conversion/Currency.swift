//
//  Currency.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 31/05/2023.
//

import Foundation

struct CurrencySymbols {
    static let symbols = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTC", "BTN", "BWP", "BYN", "BYR", "BZD", "CAD", "CDF", "CHF", "CLF", "CLP", "CNY", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "STD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VES", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMK", "ZMW", "ZWL"]

    static func indexOf(_ symbol: String) -> Int? {
        self.symbols.lastIndex(where: {$0 == symbol})
    }
    
    static func nextIndex(after index: Int) -> Int {
        if index == symbols.count - 1 {
            return index - 1
        }
        return index + 1
    }
}

class CurrencyConverter: Decodable {
    typealias CurrencySymbol = String
    var rates: [String: Double]
}

extension CurrencyConverter {
    
    func convert(from base: CurrencySymbol, to target: CurrencySymbol, amount: Double) -> Double {
        let rate = getRate(between: base, and: target)
        return (amount * rate)
    }
    
    private func getRate(between base: CurrencySymbol, and target: CurrencySymbol) -> Double {
        guard base != "EUR" else {
            return rates[target] ?? 0
        }
        guard let baseRate = rates[base] else {
            return 0
        }
        guard let targetRate = rates[target] else {
            return 0
        }

        return targetRate / baseRate
    }
}
