//
//  WatchlistView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import SwiftUI

struct WatchlistView: View {
    @State var viewModel: WatchlistViewModel
    
    init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel.symbols) { symbol in
                SymbolDataView(viewModel: symbol)
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.removeSymbolFromWatchlist(at: indexSet)
                }
            }
        }
        .navigationTitle(viewModel.name)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.showAddSymbolView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .loadingOverlay(isLoading: Binding(get: {
            viewModel.isLoading
        }, set: { _ in
        }))
        .fullScreenCover(isPresented: $viewModel.isAddSymbolViewShowing) {
            AddSymbolView(viewModel: AddSymbolViewModel(watchlist: viewModel.watchlist,
                                                      delegate: viewModel))
        }
    }
}

#Preview {
    NavigationView {
        WatchlistView(viewModel: WatchlistViewModel(watchlist: watchList1))
    }
}
