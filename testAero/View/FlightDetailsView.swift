//
//  FlightsDetailView.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import SwiftUI

struct FlightDetailsView: View {
    var flight: FlightResult
    var originCity: City
    var destinationCity: City
    var price: Price
    var searchResponse: SearchResponse
    var outputFormatHours: String = "HH:mm"
    var outputFormatDays: String = "d MMM, E"
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var inputDateFormat: String
    @State private var showAlert = false

    private var formattedPrice: String {
        "\(String(format: "%.0f", flight.price?.value ?? 0)) \(CurrencySymbol.symbol(for: price.currency ?? ""))"
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
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            // логотип авиакомпании и название
                            HStack {
                                if let airline = flight.airline {
                                    AirlineImageProvider.airlineImage(for: airline, colorScheme: colorScheme)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    Text("\(airline)")
                                        .font(.headline)
                                        .foregroundStyle(Color.textPrimaryBlack)
                                }
                            }
                            // город отправления и время
                            flightCityTimeRow(city: originCity.name ?? "", time: departureTime)
                            // IATA и дата отправления
                            flightIataDateRow(iata: originCity.iata ?? "", date: departureDate)
                            // город назначения и время
                            flightCityTimeRow(city: destinationCity.name ?? "", time: arrivalTime)
                            // IATA и дата прибытия
                            flightIataDateRow(iata: destinationCity.iata ?? "", date: arrivalDate)
                        }
                        .padding()
                        .background(Color.backgroundSecondary)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 80)
            }
            purchaseButton
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundColor(Color.textSecondaryBlue)
                        Text("Все билеты")
                            .foregroundStyle(Color.textSecondaryBlue)
                    }
                }
        )
        .alert(isPresented: $showAlert) {
            AlertHelper.showAlertDismiss(message: "Билет куплен за \(formattedPrice)", dismissText: "Отлично")
        }
    }

    // цена, кол-во пассажиров и города поездки (из в)
    private var headerSection: some View {
        VStack(alignment: .center, spacing: 15) {
            Text(formattedPrice)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.textPrimaryBlack)
            if let passengersCount = searchResponse.passengersCount {
                Text("Лучшая цена за \(passengersCount) чел")
                    .foregroundStyle(Color.textPrimaryBlack)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
            Text("\(originCity.name ?? "") — \(destinationCity.name ?? "")")
                .font(.title3)
                .bold()
                .foregroundStyle(Color.textPrimaryBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: 20, y: 10)
        }
    }

    // города и время вылета/прилета
    private func flightCityTimeRow(city: String, time: String) -> some View {
        HStack {
            Text(city)
                .font(.headline)
                .foregroundStyle(Color.textPrimaryBlack)
            Spacer()
            Text(time)
                .font(.headline)
                .foregroundStyle(Color.textPrimaryBlack)
        }
    }

    // код городов и даты вылета/прилета
    private func flightIataDateRow(iata: String, date: String) -> some View {
        HStack {
            Text(iata)
                .font(.footnote)
                .foregroundStyle(Color.textSecondaryGray)
            Spacer()
            Text(date)
                .font(.callout)
                .foregroundStyle(Color.textSecondaryGray)
        }
    }

    // кнопка покупки билета
    private var purchaseButton: some View {
        Button(action: {
            showAlert = true
        }) {
            Text("Купить билет за \(formattedPrice)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
        }
    }
}
