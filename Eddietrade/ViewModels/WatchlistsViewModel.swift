//
//  WatchlistsViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies

@MainActor
@Observable
class WatchlistsViewModel {
    private(set) var state: State = .loading
    var isLoading: Bool { if case .loading = state {
        return true
    } else {
        return false
    }}
    var alert: AlertViewModel?
    var isAddWatchlistViewShowing = false
    
    nonisolated func refreshWatchLists(showLoading: Bool = false) async {
        if showLoading {
            await setLoadingState()
        }
        
        @Dependency(\.watchlistService) var watchListService
        do {
            let watchlists = try await watchListService.getWatchlists()
            await setLoadedState(watchlists)
        } catch {
            await setLoadedState([])
            await showAlert(title: "Watchlist Error", message: "Could not retrieve Watchlists")
        }
    }
    
    nonisolated func deleteWatchlist(at indexSet: IndexSet) async {
        guard case let .loaded(watchlists) = await state,
            let index = indexSet.first,
            let deletedWatchlist = watchlists.indices.contains(index) ? watchlists[index] : nil else {
            return
        }
        
        await setLoadingState()
        
        do {
            @Dependency(\.watchlistService) var watchListService
            try await watchListService.deleteWatchlist(deletedWatchlist.name)
        } catch {
            await showAlert(title: "Watchlist Error", message: "Could not delete watchlists")
        }
        
        await refreshWatchLists()
    }
    
    func showAddWatchlistView() {
        isAddWatchlistViewShowing = true
    }
}

extension WatchlistsViewModel {
    private func setLoadingState() {
        state = .loading
    }
    
    private func setLoadedState(_ watchLists: [Watchlist]) {
        state = .loaded(watchLists.map({ WatchlistViewModel(watchlist: $0) }))
    }
    
    private func showAlert(title: String, message: String) {
        alert = .init(title: title, message: message)
    }
}

extension WatchlistsViewModel {
    enum State {
        case loading
        case loaded([WatchlistViewModel])
    }
}
