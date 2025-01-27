//
//  WatchlistViewModelTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/26/25.
//

import Foundation
import Dependencies
import Testing
@testable import Eddietrade

struct WatchlistViewModelTests {

    struct RemoveSymbolFromWatchlist {
        @MainActor
        @Test("Call removeSymbolFromWatchlist and is successful")
        func valid() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.testValue
            } operation: {
                let viewModel = WatchlistViewModel(watchlist: watchList1)
                await viewModel.removeSymbolFromWatchlist(at: IndexSet(integer: 0))
                #expect(viewModel.alert == nil)
            }
        }
        
        @MainActor
        @Test("Call removeSymbolFromWatchlist and alert is set")
        func failure() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.failureValue
            } operation: {
                let viewModel = WatchlistViewModel(watchlist: watchList1)
                await viewModel.removeSymbolFromWatchlist(at: IndexSet(integer: 0))
                #expect(viewModel.alert != nil)
            }
        }
    }
}
