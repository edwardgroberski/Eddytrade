//
//  Data+Extensions.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import Foundation

enum JSONFile: String {
    case login = "login_response"
    case watchlists = "get_watchlists_response"
    case watchlist = "watchlist_response"
    case symbols = "symbol_search_response"
    case marketData = "market_data_response"
}

extension Data {
    init(jsonFile: String) {
        let url = Bundle.main.url(forResource: jsonFile, withExtension: "json")!
        try! self.init(contentsOf: url)
    }
}
