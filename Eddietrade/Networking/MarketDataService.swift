//
//  MarketDataService.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

import Foundation
import Dependencies

struct MarketDataService: Sendable {
    var data: @Sendable (String) async throws -> MarketData
    
    enum API: String, Codable {
        case data = "https://api.cert.tastyworks.com/market-data"
    }
}

extension MarketDataService: DependencyKey {
    static var liveValue: MarketDataService {
        @Dependency(\.apiClient) var apiClient
        
        return Self { symbol in
            let url = URL(string: API.data.rawValue + "/\(symbol)")!
            let result = await apiClient.fetch(.get, url, nil)
            
            switch result {
            case .success(let data):
                let response = try JSONDecoder().decode(Response<MarketData>.self, from: data)
                return response.data
            case .failure(let error):
                throw error
            }
        }
    }
    
    static var testValue: MarketDataService {
        return Self { _ in
            return marketData1
        }
    }
    
    static var previewValue: MarketDataService {
        return Self { _ in
            return marketData1
        }
    }
    
    static var failureValue: MarketDataService {
        return Self { _ in
            throw APIClient.Error.failure
        }
    }
}

extension DependencyValues {
    var marketDataService: MarketDataService {
        get { self[MarketDataService.self] }
        set { self[MarketDataService.self] = newValue }
    }
}
