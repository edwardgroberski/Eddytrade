//
//  SymbolSearchResultViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

struct SymbolSearchResultViewModel: Equatable, Identifiable  {
    let symbol: String
    let description: String
    let inCurrentWatchList: Bool
    
    var id: String {
        symbol
    }
    
    init(symbol: Symbol, inCurrentWatchList: Bool) {
        self.symbol = symbol.symbol
        self.description = symbol.description
        self.inCurrentWatchList = inCurrentWatchList
    }
}
