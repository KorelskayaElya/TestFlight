//
//  FlightSearchViewModel.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import Foundation
import OSLog
import Observation

@Observable
final class FlightSearchViewModel {
    @MainActor var flightResults: [FlightResult] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var searchResponse: SearchResponse?
    @ObservationIgnored var inputDateFormat: String = "yyyy-MM-dd HH:mm"
    private let logger: LoggerService = OSLogLogger.shared

    // сортировка цены от меньшей к большей
    @MainActor
    var sortedFlights: [FlightResult] {
        flightResults.sorted { ($0.price?.value ?? 0) < ($1.price?.value ?? 0) }
    }

    // MARK: - Functions

    // получение данных по запросу
    func fetchFlights(origin: String, destination: String) async {
        guard let url = URL(string: "https://nu.vsepoka.ru/api/search?origin=\(origin)&destination=\(destination)") else {
            await MainActor.run {
                self.errorMessage = "Invalid URL"
                self.logger.logEvent(
                    message: "[FlightSearchViewModel] Invalid URL provided for origin: \(origin) and destination: \(destination)",
                    type: .error
                )
            }
            return
        }

        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            await MainActor.run {
                self.searchResponse = decodedResponse
                self.flightResults = decodedResponse.results ?? []
                self.isLoading = false
            }
            self.logger.logEvent(
                message: "[FlightSearchViewModel searchResponse] \(String(describing: searchResponse))",
                type: .other
            )
            self.logger.logEvent(
                message: "[FlightSearchViewModel flightResults] \(await flightResults)",
                type: .other
            )
        } catch {
            await MainActor.run {
                self.logger.logEvent(
                    message: "[FlightSearchViewModel] Error fetching or decoding data: \(error.localizedDescription)",
                    type: .error
                )
                self.isLoading = false
                self.errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }

    // отправка повторного запроса на получение данных
    func retryFetchFlights(origin: String, destination: String) async {
        await fetchFlights(origin: origin, destination: destination)
    }

}
