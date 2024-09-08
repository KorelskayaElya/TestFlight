//
//  SearchResultItemView.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import SwiftUI

struct SearchResultItemView: View {
    var flight: FlightResult
    var originCity: City
    var destinationCity: City
    var price: Price
    var searchResponse: SearchResponse
    var outputFormatHours: String = "HH:mm"
    var outputFormatDays: String = "d MMM, E"
    var inputDateFormat: String
    @Environment(\.colorScheme) var colorScheme

    private var formattedPrice: String {
        "\(String(format: "%.0f", price.value ?? 0)) \(CurrencySymbol.symbol(for: price.currency ?? ""))"
    }

    private var departureTime: String {
        DateFormatterHelper.formattedDate(from: flight.departureDateTime, inputFormat: inputDateFormat, outputFormat: outputFormatHours)
    }

    private var arrivalTime: String {
        DateFormatterHelper.formattedDate(from: flight.arrivalDateTime, inputFormat: inputDateFormat, outputFormat: outputFormatHours)
    }

    private var departureDate: String {
        DateFormatterHelper.formattedDate(from: flight.departureDateTime, inputFormat: inputDateFormat, outputFormat: outputFormatDays)
    }

    private var arrivalDate: String {
        DateFormatterHelper.formattedDate(from: flight.arrivalDateTime, inputFormat: inputDateFormat, outputFormat: outputFormatDays)
    }

    var body: some View {
        NavigationLink(destination: FlightDetailsView(
            flight: flight,
            originCity: originCity,
            destinationCity: destinationCity,
            price: price,
            searchResponse: searchResponse,
            inputDateFormat: inputDateFormat
        )) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(formattedPrice)
                            .font(.title)
                            .foregroundColor(Color.textSecondaryBlue)
                        Spacer()
                        if let airline = flight.airline {
                            AirlineImageProvider.airlineImage(for: airline, colorScheme: colorScheme)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        }
                    }
                    if let ticketsCount = flight.availableTicketsCount, ticketsCount < 10 {
                        Text("Осталось \(ticketsCount) билетов по этой цене")
                            .font(.caption)
                            .foregroundColor(Color.textTertiaryRed)
                    }
                    VStack {
                        HStack {
                            Text(originCity.name ?? "")
                                .font(.headline)
                                .foregroundStyle(Color.textPrimaryBlack)
                            Spacer()
                            Text(departureTime)
                                .font(.headline)
                                .foregroundStyle(Color.textPrimaryBlack)
                        }
                        HStack {
                            Text(originCity.iata ?? "")
                                .font(.footnote)
                                .foregroundStyle(Color.textSecondaryGray)
                            Spacer()
                            Text(departureDate)
                                .font(.callout)
                                .foregroundStyle(Color.textSecondaryGray)
                        }
                        HStack {
                            Text(destinationCity.name ?? "")
                                .font(.headline)
                                .foregroundStyle(Color.textPrimaryBlack)
                            Spacer()
                            Text(arrivalTime)
                                .font(.headline)
                                .foregroundStyle(Color.textPrimaryBlack)
                        }
                        HStack {
                            Text(destinationCity.iata ?? "")
                                .font(.footnote)
                                .foregroundStyle(Color.textSecondaryGray)
                            Spacer()
                            Text(arrivalDate)
                                .font(.callout)
                                .foregroundStyle(Color.textSecondaryGray)
                        }
                    }
                }
            }
        }
    }
}

