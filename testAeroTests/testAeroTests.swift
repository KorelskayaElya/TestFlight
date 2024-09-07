//
//  testAeroTests.swift
//  testAeroTests
//
//  Created by Эля Корельская on 07.09.2024.
//

import XCTest
@testable import testAero

final class FlightSearchUnitTests: XCTestCase {
    var viewModel: FlightSearchViewModel!

    override func setUp() {
        super.setUp()
        viewModel = FlightSearchViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // тест на успешное получение данных из сети
    @MainActor
    func testFetchFlightsSuccess() async {
        await viewModel.fetchFlights(origin: "MOW", destination: "LED")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.searchResponse)
        XCTAssertEqual(
            viewModel.flightResults.count,
            viewModel.searchResponse?.results?.count ?? 0
        )
    }

    // тест сортировки билетов по цене
    @MainActor
    func testSortedFlights() {
        viewModel.flightResults = [
            FlightResult(id: "1", departureDateTime: nil, arrivalDateTime: nil, price: Price(currency: "₽", value: 1000), airline: nil, availableTicketsCount: nil),
            FlightResult(id: "2", departureDateTime: nil, arrivalDateTime: nil, price: Price(currency: "₽", value: 500), airline: nil, availableTicketsCount: nil),
            FlightResult(id: "3", departureDateTime: nil, arrivalDateTime: nil, price: Price(currency: "₽", value: 1500), airline: nil, availableTicketsCount: nil)
        ]
        let sortedFlights = viewModel.sortedFlights
        XCTAssertEqual(sortedFlights[0].price?.value, 500)
        XCTAssertEqual(sortedFlights[1].price?.value, 1000)
        XCTAssertEqual(sortedFlights[2].price?.value, 1500)
    }

}
