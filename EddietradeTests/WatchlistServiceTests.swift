//
//  WatchlistServiceTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/25/25.
//

import Dependencies
import Testing
@testable import Eddietrade

struct WatchlistServiceTests {

    struct GetWatchLists {
        @Test("Call getWatchlists and receive watchlists")
        func valid() async throws {
            try await withDependencies {
                $0.apiClient = .watchlistsResponseValue
            } operation: {
                let service = WatchlistService.liveValue
                let watchlists = try await service.getWatchlists()
                #expect(watchlists.count == 2)
            }
        }
        
        @Test("Call getWatchlists and receive failure")
        func failure() async throws {
            await withDependencies {
                $0.apiClient = .failureValue
            } operation: {
                let service = WatchlistService.liveValue
                await #expect(throws: (any Error).self) {
                    try await service.getWatchlists()
                }
            }
        }
    }
    
    struct CreateWatchList {
        @Test("Call createWatchlist and receive watchlist")
        func valid() async throws {
            try await withDependencies {
                $0.apiClient = .watchlistResponseValue
            } operation: {
                let service = WatchlistService.liveValue
                let watchlist = try await service.createWatchlist(watchList1)
                #expect(watchlist.name == "Name")
            }
        }
        
        @Test("Call createWatchlist and receive failure")
        func failure() async throws {
            await withDependencies {
                $0.apiClient = .failureValue
            } operation: {
                let service = WatchlistService.liveValue
                await #expect(throws: (any Error).self) {
                    try await service.createWatchlist(watchList1)
                }
            }
       }
    }
    
    struct UpdateWatchList {
        @Test("Call updateWatchlist and receive watchlist")
        func valid() async throws {
            try await withDependencies {
                $0.apiClient = .watchlistResponseValue
            } operation: {
                let service = WatchlistService.liveValue
                let watchlist = try await service.updateWatchlist(watchList1)
                #expect(watchlist.name == "Name")
            }
        }
        
        @Test("Call updateWatchlist and receive failure")
        func failure() async throws {
            await withDependencies {
                $0.apiClient = .failureValue
            } operation: {
                let service = WatchlistService.liveValue
                await #expect(throws: (any Error).self) {
                    try await service.updateWatchlist(watchList1)
                }
            }
        }
    }
    
    struct DeleteWatchList {
        @Test("Call deleteWatchlist and succeed")
        func valid() async throws {
            try await withDependencies {
                $0.apiClient = .watchlistResponseValue
            } operation: {
                let service = WatchlistService.liveValue
                try await service.deleteWatchlist("")
            }
        }
        
        @Test("Call deleteWatchlist and receive failure")
        func failure() async throws {
            await withDependencies {
                $0.apiClient = .failureValue
            } operation: {
                let service = WatchlistService.liveValue
                await #expect(throws: (any Error).self) {
                    try await service.deleteWatchlist("")
                }
            }
        }
    }
}
