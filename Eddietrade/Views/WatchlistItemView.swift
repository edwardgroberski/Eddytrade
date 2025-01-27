//
//  WatchlistItemView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import SwiftUI

struct WatchlistItemView: View {
    let watchlist: Watchlist
    
    init(watchlist: Watchlist) {
        self.watchlist = watchlist
    }
    
    var body: some View {
        Text(watchlist.name)
    }
}

#Preview {
    WatchlistItemView(watchlist: watchList1)
}
