//
//  SearchResponse.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import UIKit

struct SearchResponse: Codable {
    // количество пассажиров
    let passengersCount: Int?
    // город отправления
    let origin: City?
    // город назначения
    let destination: City?
    // результат перелета
    let results: [FlightResult]?

    enum CodingKeys: String, CodingKey {
        case passengersCount = "passengers_count"
        case origin
        case destination
        case results
    }
}

struct City: Codable {
    // IATA код города
    let iata: String?
    // Название города
    let name: String?

    enum CodingKeys: String, CodingKey {
        case iata
        case name
    }
}

struct FlightResult: Codable, Identifiable {
    // Идентификатор результата перелета
    let id: String?
    // Дата и время отправления
    let departureDateTime: String?
    // Дата и время прибытия
    let arrivalDateTime: String?
    // Цена перелета
    let price: Price?
    // Название авиакомпании
    let airline: String?
    // Количество доступных билетов
    let availableTicketsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case departureDateTime = "departure_date_time"
        case arrivalDateTime = "arrival_date_time"
        case price
        case airline
        case availableTicketsCount = "available_tickets_count"
    }
}

struct Price: Codable {
    // Код валюты
    let currency: String?
    // Значение цены
    let value: Double?

    enum CodingKeys: String, CodingKey {
        case currency
        case value
    }
}

