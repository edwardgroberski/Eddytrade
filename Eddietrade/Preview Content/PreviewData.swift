//
//  PreviewData.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//
import Foundation

let watchList1 = Watchlist(name: "Watch List 1",
                           watchlistEntries: [watchListEntry1, watchListEntry2])

let watchList2 = Watchlist(name: "Watch List 2",
                           watchlistEntries: [watchListEntry3, watchListEntry4])

let watchListEntry1 = WatchListEntry(symbol: "AAPL")
let watchListEntry2 = WatchListEntry(symbol: "AA")
let watchListEntry3 = WatchListEntry(symbol: "NVDA")
let watchListEntry4 = WatchListEntry(symbol: "GME")

let symbol1 = Symbol(symbol: "AAPL", description: "Apple Inc. - Common Stock")

let marketData1 = MarketData(
    symbol: "AA",
    bid: "37.25",
    ask: "37.4",
    last: "37.43"
)
