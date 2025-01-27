//
//  Symbol.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

struct Symbol: Codable, Equatable, Identifiable {
    let symbol: String
    let description: String
    
    var id: String {
        symbol
    }
}
