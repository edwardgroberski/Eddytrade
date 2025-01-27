//
//  MarketData.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

import Foundation

struct MarketData: Codable {
    var symbol: String
    var bid: String
    var ask: String
    var last: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case bid
        case ask
        case last
    }
}
