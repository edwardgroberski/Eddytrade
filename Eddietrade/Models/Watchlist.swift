//
//  Watchlist.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation

struct Watchlist: Codable, Equatable, Identifiable {
    let name: String
    let entries: [WatchListEntry]
    let groupName: String?
    let orderIndex: Int
    
    var id: String {
        name
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case entries = "watchlist-entries"
        case groupName = "group-name"
        case orderIndex = "order-index"
    }
    
    init(name: String, watchlistEntries: [WatchListEntry] = [], groupName: String? = nil, orderIndex: Int = 9999) {
        self.name = name
        self.entries = watchlistEntries
        self.groupName = groupName
        self.orderIndex = orderIndex
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        entries = try container.decodeIfPresent([WatchListEntry].self, forKey: .entries) ?? []
        groupName = try container.decodeIfPresent(String.self, forKey: .groupName) ?? nil
        orderIndex = try container.decodeIfPresent(Int.self, forKey: .orderIndex) ?? 9999
    }
    
    func copy(withEntries: [WatchListEntry]) -> Watchlist {
        return Watchlist(name: name, watchlistEntries: withEntries, groupName: groupName, orderIndex: orderIndex)
    }
    
    static func == (lhs: Watchlist, rhs: Watchlist) -> Bool {
        lhs.name == rhs.name
    }
}

struct WatchListEntry: Codable, Equatable, Identifiable {
    let symbol: String
    let instrumentType: String? = nil
    
    var id: String {
        symbol
    }
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case instrumentType = "instrument-type"
    }
}
