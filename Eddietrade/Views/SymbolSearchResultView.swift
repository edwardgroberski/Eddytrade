//
//  SymbolSearchResultView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

import SwiftUI

struct SymbolSearchResultView: View {
    private let viewModel: SymbolSearchResultViewModel
    
    init(viewModel: SymbolSearchResultViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.symbol)
                    .font(.title2)
                Text(viewModel.description)
                    .font(.subheadline)
            }
            Spacer()
            if viewModel.inCurrentWatchList {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.green)
            }
        }
        .padding(8)
    }
}

#Preview("inCurrentWatchList true") {
    List {
        SymbolSearchResultView(viewModel: SymbolSearchResultViewModel(symbol: Symbol(symbol: "AA",
                                                                                     description: "American Airlines"),
                                                                      inCurrentWatchList: true))
    }
}

#Preview("inCurrentWatchList false") {
    SymbolSearchResultView(viewModel: SymbolSearchResultViewModel(symbol: Symbol(symbol: "AA",
                                                                                 description: "American Airlines"),
                                                                  inCurrentWatchList: false))
}
