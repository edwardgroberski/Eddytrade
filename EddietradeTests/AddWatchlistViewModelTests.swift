//
//  AddWatchlistViewModelTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/25/25.
//

import Dependencies
import Testing
import SwiftUI
@testable import Eddietrade

struct AddWatchlistViewModelTests {
    
    struct CreateWatchlist {
        @MainActor
        @Test("Call createWatchlist and dismiss is called")
        func valid() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.testValue
            } operation: {
                let viewModel = AddWatchlistViewModel()
                viewModel.name = "name"
                var dismissCalled = false
                await viewModel.createWatchlist { dismissCalled = true }
                #expect(dismissCalled)
                #expect(viewModel.alert == nil)
            }
        }
        
        @MainActor
        @Test("Call createWatchlist with api failure and show alert")
        func apiFailure() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.failureValue
            } operation: {
                let viewModel = AddWatchlistViewModel()
                viewModel.name = "name"
                var dismissCalled = false
                await viewModel.createWatchlist { dismissCalled = true }
                #expect(!dismissCalled)
                #expect(viewModel.alert != nil)
            }
        }
        
        @MainActor
        @Test("Call createWatchlist with empty and show alert")
        func nameFailure() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.failureValue
            } operation: {
                let viewModel = AddWatchlistViewModel()
                var dismissCalled = false
                await viewModel.createWatchlist { dismissCalled = true }
                #expect(!dismissCalled)
                #expect(viewModel.alert != nil)
            }
        }
    }
}
