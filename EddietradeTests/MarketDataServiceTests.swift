//
//  MarketDataServiceTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/26/25.
//

import Dependencies
import Testing
@testable import Eddietrade

struct MarketDataServiceTests {

    @Test("Call data and receive results")
    func valid() async throws {
        let service = withDependencies {
            $0.apiClient = .marketDataResponseValue
        } operation: {
            MarketDataService.liveValue
        }
        let result = try await service.data("")
        #expect(result.symbol == "AA")
    }
    
    
    @Test("Call data and receive error")
    func failure() async throws {
        let service = withDependencies {
            $0.apiClient = .failureValue
        } operation: {
            MarketDataService.liveValue
        }
        await #expect(throws: (any Error).self) {
            try await service.data("")
        }
    }

}
