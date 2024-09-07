//
//  AirlineImageProvider.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import SwiftUI

struct AirlineImageProvider {
    // получение логотипа в зависимости от colorScheme
    static func airlineImage(for airline: String, colorScheme: ColorScheme) -> Image {
        switch airline {
        case "Аэрофлот":
            return colorScheme == .light ? Image("aeroflot1") : Image("aeroflot2")
        case "S7":
            return colorScheme == .light ? Image("s7") : Image("s72")
        case "Победа":
            return colorScheme == .light ? Image("pobeda1") : Image("pobeda2")
        case "Smartavia":
            return colorScheme == .light ? Image("smart1") : Image("smart2")
        default:
            return Image("aeroflot1")
        }
    }
}
