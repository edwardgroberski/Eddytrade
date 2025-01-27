//
//  SymbolServiceTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/25/25.
//

import Dependencies
import Testing
@testable import Eddietrade

struct SymbolServiceTests {

    @Test("Call search and receive results")
    func valid() async throws {
        let service = withDependencies {
            $0.apiClient = .symbolsResponseValue
        } operation: {
            SymbolService.liveValue
        }
        let results = try await service.search("")
        #expect(!results.isEmpty)
    }
    
    
    @Test("Call search and receive error")
    func failure() async throws {
        let service = withDependencies {
            $0.apiClient = .failureValue
        } operation: {
            SymbolService.liveValue
        }
        await #expect(throws: (any Error).self) {
            try await service.search("")
        }
    }
}
