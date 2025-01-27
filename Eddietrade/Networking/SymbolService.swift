//
//  SymbolService.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies

struct SymbolService: Sendable {
    var search: @Sendable (String) async throws -> [Symbol]
    
    enum API: String, Codable {
        case search = "https://vast.tastyworks.com/symbols/search/"
    }
}

extension SymbolService: DependencyKey {
    static var liveValue: SymbolService {
        @Dependency(\.apiClient) var apiClient
        
        return Self { search in
            let url = URL(string: API.search.rawValue + "/\(search)")!
            let result = await apiClient.fetch(.get, url, nil)
            
            switch result {
            case .success(let data):
                let response = try JSONDecoder().decode(Response<ItemsResponse<Symbol>>.self, from: data)
                return response.data.items
            case .failure(let error):
                throw error
            }
        }
    }
    
    static var testValue: SymbolService {
        return Self { _ in
            return [symbol1]
        }
    }
    
    static var previewValue: SymbolService {
        return Self { _ in
            return [symbol1]
        }
    }
    
    static var failureValue: SymbolService {
        return Self { _ in
            throw APIClient.Error.failure
        }
    }
}

extension DependencyValues {
    var symbolService: SymbolService {
        get { self[SymbolService.self] }
        set { self[SymbolService.self] = newValue }
    }
}
