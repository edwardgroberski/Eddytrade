//
//  WatchlistsView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import SwiftUI

struct WatchlistsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var viewModel = WatchlistsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .loaded(let watchlists):
                    watchlistsView(watchlists)
                case .loading:
                    loadingView
                }
            }
            .navigationTitle("Watchlists")
            .alert(model: $viewModel.alert)
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.showAddWatchlistView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isAddWatchlistViewShowing, onDismiss: {
                Task {
                    await viewModel.refreshWatchLists(showLoading: true)
                }
            }) {
                return AddWatchlistView()
            }
            .onAppear {
                Task {
                    await viewModel.refreshWatchLists(showLoading: true)
                }
            }
        }.tint(colorScheme == .dark ? .white: .black)
    }
    
    @ViewBuilder
    private func watchlistsView(_ watchlist: [WatchlistViewModel]) -> some View {
        List {
            ForEach(watchlist) { watchlist in
                NavigationLink(destination: NavigationLazyView(WatchlistView(viewModel: watchlist))
                ) {
                    WatchlistItemView(watchlist: watchlist.watchlist)
                }
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.deleteWatchlist(at: indexSet)
                }
            }
        }
        .refreshable {
            await viewModel.refreshWatchLists()
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
            .padding()
    }
}

#Preview {
    WatchlistsView()
}
