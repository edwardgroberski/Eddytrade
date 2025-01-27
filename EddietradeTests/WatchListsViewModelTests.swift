//
//  WatchListsViewModelTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies
import Testing
@testable import Eddietrade

struct WatchListsViewModelTests {
    
    struct RefreshWatchlists {
        @MainActor
        @Test("Call refreshWatchLists and state is loaded with watchlists")
        func valid() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.testValue
            } operation: {
                let viewModel = WatchlistsViewModel()
                await viewModel.refreshWatchLists()
                #expect(viewModel.alert == nil)
            }
        }
        
        @MainActor
        @Test("Call refreshWatchLists and state is loaded with empty watchlists")
        func failure() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.failureValue
            } operation: {
                let viewModel = WatchlistsViewModel()
                await viewModel.refreshWatchLists()
                #expect(viewModel.alert != nil)
            }
        }
    }
    
    struct DeleteWatchlist {
        @MainActor
        @Test("Call deleteWatchlist and is successful")
        func valid() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.testValue
            } operation: {
                let viewModel = WatchlistsViewModel()
                await viewModel.refreshWatchLists()
                await viewModel.deleteWatchlist(at: IndexSet(integer: 0))
                #expect(viewModel.alert == nil)
            }
        }
        
        @MainActor
        @Test("Call deleteWatchlist and alert is set")
        func failure() async {
            await withDependencies {
                $0.watchlistService = WatchlistService.failureValue
            } operation: {
                let viewModel = WatchlistsViewModel()
                await viewModel.refreshWatchLists()
                await viewModel.deleteWatchlist(at: IndexSet(integer: 0))
                #expect(viewModel.alert != nil)
            }
        }
    }

    @MainActor
    @Test("Call showAddWatchlistView sets isAddWatchlistViewShowing true")
    func showAddWatchlistView() async {
        withDependencies {
            $0.watchlistService = WatchlistService.testValue
        } operation: {
            let viewModel = WatchlistsViewModel()
            #expect(!viewModel.isAddWatchlistViewShowing)
            viewModel.showAddWatchlistView()
            #expect(viewModel.isAddWatchlistViewShowing)
        }
    }
}
