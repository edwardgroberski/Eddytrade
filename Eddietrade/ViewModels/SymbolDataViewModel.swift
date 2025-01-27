//
//  SymbolDataViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

import Foundation
import Dependencies

@MainActor
@Observable
class SymbolDataViewModel: Identifiable {
    let symbol: String
    private var marketData: MarketData? = nil
    
    private var task: Task<Void, Never>? = nil
    
    let id: String
    
    private(set) var error = false
    
    var bidPrice: String {
        marketData?.bid ?? "-"
    }
    
    var askPrice: String {
        marketData?.ask ?? "-"
    }
    
    var lastPrice: String {
        marketData?.last ?? "-"
    }
    
    @ObservationIgnored
    @Dependency(\.marketDataService) var marketDataService
    
    
    init(symbol: String) {
        self.id = symbol
        self.symbol = symbol
        self.marketData = marketData
    }
    
    func pollMarketData() {
        task = Task.detached { [weak self] in
            do {
                while true {
                    await self?.refreshMarketData()
                    try await Task.sleep(nanoseconds: 5_000_000_000)
                }
            } catch {
                await self?.setMarketData(nil)
            }
        }
    }
    
    func cancelPollMarketData() {
        task?.cancel()
    }
    
    nonisolated private func refreshMarketData() async {
        do {
            let newMarketData = try await marketDataService.data(symbol)
            await setMarketData(newMarketData)
        } catch {
            await setMarketData(nil)
        }
    }
    
    @MainActor
    private func setMarketData(_ newMarketData: MarketData?) {
        self.marketData = newMarketData
    }
}
