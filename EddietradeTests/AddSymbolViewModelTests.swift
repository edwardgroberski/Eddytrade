//
//  AddSymbolViewModelTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/26/25.
//

import Foundation
import Dependencies
import Testing
@testable import Eddietrade

class MockAddSymbolViewModelDelegate: AddSymbolViewModelDelegate {
    var didSelectSymbolCalled = false
    func didSelectSymbol(_ symbol: String) {
        didSelectSymbolCalled = true
    }
}

struct AddSymbolViewModelTests {

    @MainActor
    @Test("call selectedSymbol calls delegate and dismiss")
    func selectSymbol() async {
        let delegate = MockAddSymbolViewModelDelegate()
        let viewModel = AddSymbolViewModel(watchlist: watchList1, delegate: delegate)
        var dismissCalled = false
        viewModel.selectedSymbol(SymbolSearchResultViewModel(symbol: Symbol(symbol: "",
                                                                            description: ""),
                                                             inCurrentWatchList: false)) {
            dismissCalled = true
        }
        #expect(delegate.didSelectSymbolCalled)
        #expect(dismissCalled)
    }
}
