//
//  AddSymbolViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies
import Combine

protocol AddSymbolViewModelDelegate: AnyObject {
    func didSelectSymbol(_ symbol: String)
}

@MainActor
@Observable
class AddSymbolViewModel {
    private let currentStockSymbols: Set<String>
    private weak var delegate: AddSymbolViewModelDelegate?
    private(set) var symbolSearchResultViewModels = [SymbolSearchResultViewModel]()
    private var cancellables = Set<AnyCancellable>()
    private var debounceTimer: Timer?
    private let searchDelay: TimeInterval = 0.5
    
    var searchText = "" {
        didSet {
            debounceSearch()
        }
    }
    
    @ObservationIgnored
    @Dependency(\.symbolService) var symbolService
    
    init(watchlist: Watchlist, delegate: AddSymbolViewModelDelegate? = nil) {
        self.currentStockSymbols = Set(watchlist.entries.map { $0.symbol })
        self.delegate = delegate
    }
    
    func selectedSymbol(_ symbol: SymbolSearchResultViewModel, dismiss: () -> Void)  {
        guard !symbol.inCurrentWatchList else {
            return
        }
        
        delegate?.didSelectSymbol(symbol.symbol)
        dismiss()
    }
    
    private func debounceSearch() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { [weak self] _ in
            Task {
                await self?.search()
            }
        }
    }
    
    private func search() async {
        guard !searchText.isEmpty else {
            symbolSearchResultViewModels = []
            return
        }
        
        do {
            let symbols = try await symbolService.search(searchText)
            self.symbolSearchResultViewModels = symbols.map({ symbol in
                let inCurrentWatchlist = currentStockSymbols.contains(symbol.symbol)
                return SymbolSearchResultViewModel(symbol: symbol, inCurrentWatchList: inCurrentWatchlist)
            })
        } catch {
            symbolSearchResultViewModels = []
        }
    }
}
