//
//  CurrencySymbol.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import Foundation

enum CurrencySymbol: String {
    case rub = "₽"
    case usd = "$"
    case eur = "€"
    case gbp = "£"

    // получение символа валюты из ее аббревиатуры 
    static func symbol(for currencyCode: String) -> String {
        switch currencyCode.uppercased() {
        case "RUB":
            return CurrencySymbol.rub.rawValue
        case "USD":
            return CurrencySymbol.usd.rawValue
        case "EUR":
            return CurrencySymbol.eur.rawValue
        case "GBP":
            return CurrencySymbol.gbp.rawValue
        default:
            return currencyCode
        }
    }
}

