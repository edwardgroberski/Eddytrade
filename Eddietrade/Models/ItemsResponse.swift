//
//  WatchlistsResponse.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

struct ItemsResponse<T: Codable>: Codable {
    let items: [T]
}
