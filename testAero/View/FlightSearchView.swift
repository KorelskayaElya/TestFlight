//
//  FlightSearchView.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import SwiftUI

// MARK: - Views

struct FlightSearchView: View {
    @State private var viewModel = FlightSearchViewModel()
    private var origin: String = "MOW"
    private var destination: String = "LED"
    private var dateOfFlight: String = "2024-09-03 12:35"
    private var outputFormat = "d MMMM"
    @Environment(\.colorScheme) var colorScheme

    private var formattedDateOfFlight: String {
        DateFormatterHelper.formattedDate(from: dateOfFlight, inputFormat: viewModel.inputDateFormat, outputFormat: outputFormat)
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(errorMessage: errorMessage) {
                        Task {
                            await viewModel.retryFetchFlights(origin: origin, destination: destination)
                        }
                    }
                } else {
                    FlightListView(viewModel: viewModel)
                        .refreshable {
                            Task {
                                await viewModel.fetchFlights(origin: origin, destination: destination)
                            }
                        }
                }
            }
            .toolbar {
                if viewModel.errorMessage == nil {
                    ToolbarItem(placement: .principal) {
                        FlightSearchToolbar(
                            originName: viewModel.searchResponse?.origin?.name ?? "",
                            destinationName: viewModel.searchResponse?.destination?.name ?? "",
                            passengersCount: viewModel.searchResponse?.passengersCount ?? 1,
                            formattedDate: formattedDateOfFlight
                        )
                    }
                }
            }
            .background(Color.backgroundPrimary)
        }
        .onAppear {
            Task { await viewModel.fetchFlights(origin: origin, destination: destination) }
        }
    }
}

// MARK: - Components

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2)
            .padding()
            .background(Color.backgroundSecondary)
    }
}

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Что-то пошло не так")
                .font(.headline)
                .foregroundColor(Color.textTertiaryRed)
                .padding()
            
            Button(action: retryAction) {
                Text("Повторить")
                    .padding()
                    .background(Color.buttonPrimaryOrange)
                    .foregroundColor(Color.textPrimaryWhite)
                    .cornerRadius(8)
            }
        }
        .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
        .background(Color.backgroundSecondary)
    }
}

struct FlightListView: View {
    var viewModel: FlightSearchViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                let sortedFlights = viewModel.sortedFlights
                let lowestPrice = sortedFlights.first?.price?.value ?? 0

                ForEach(sortedFlights) { flight in
                    if let originCity = viewModel.searchResponse?.origin,
                       let destinationCity = viewModel.searchResponse?.destination,
                       let flightPrice = flight.price, let searchResponse = viewModel.searchResponse {
                        SearchResultItemView(
                            flight: flight,
                            originCity: originCity,
                            destinationCity: destinationCity,
                            price: flightPrice,
                            searchResponse: searchResponse,
                            isCheapest: flightPrice.value == lowestPrice,
                            inputDateFormat: viewModel.inputDateFormat
                        )
                        .customCardStyle()
                    }
                }
            }
        }
    }
}

struct FlightSearchToolbar: View {
    let originName: String
    let destinationName: String
    let passengersCount: Int
    let formattedDate: String

    var body: some View {
        VStack {
            Text("\(originName) - \(destinationName)")
                .font(.headline)
                .foregroundColor(.primary)

            Text("\(formattedDate), \(passengersCount) чел")
                .font(.subheadline)
                .foregroundColor(Color.textSecondaryGray)
        }
    }
}

// MARK: - Preview

#Preview {
    FlightSearchView()
}
