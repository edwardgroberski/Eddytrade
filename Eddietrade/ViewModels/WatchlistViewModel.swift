//
//  WatchlistViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies

@MainActor
@Observable
class WatchlistViewModel: Identifiable {
    private(set) var watchlist: Watchlist
    var isLoading = false
    var alert: AlertViewModel?
    
    var isAddSymbolViewShowing = false
    
    var name: String {
        watchlist.name
    }
    
    private(set) var symbols: [SymbolDataViewModel]
    
    init(watchlist: Watchlist) {
        self.watchlist = watchlist
        self.symbols = watchlist.entries.map { SymbolDataViewModel(symbol: $0.symbol) }
    }
    
    func showAddSymbolView() {
        isAddSymbolViewShowing = true
    }
    
    func removeSymbolFromWatchlist(at indexSet: IndexSet) async {
        var entries = watchlist.entries
        
        guard let index = indexSet.first,
            entries.indices.contains(index) else {
            return
        }
        
        entries.remove(at: index)
        await updateWatchlistWithEntries(entries)
    }
    
    private func updateWatchlistWithNewSymbol(_ symbol: String) async {
        var entries = watchlist.entries
        entries.append(WatchListEntry(symbol: symbol))
        
        await updateWatchlistWithEntries(entries)
    }
    
    private func updateWatchlistWithEntries(_ entries: [WatchListEntry]) async {
        defer {
            isLoading = false
        }
        
        isLoading = true
        let watchlist = watchlist.copy(withEntries: entries)
        
        do {
            @Dependency(\.watchlistService) var watchlistService
            let updatedWatchlist = try await watchlistService.updateWatchlist(watchlist)
            self.watchlist = updatedWatchlist
            self.symbols = watchlist.entries.map { SymbolDataViewModel(symbol: $0.symbol) }
        } catch {
            showAlert(title: "Watchlist Error", message: "Could not update Watchlist")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alert = .init(title: title, message: message)
    }
}

extension WatchlistViewModel: AddSymbolViewModelDelegate {
    
    nonisolated func didSelectSymbol(_ symbol: String) {
        Task {
            await updateWatchlistWithNewSymbol(symbol)
        }
    }
}
