//
//  APIClient.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//


import Foundation
import Dependencies
import UIKit

private let encoder = JSONEncoder()

struct APIClient: Sendable {
    var fetch: @Sendable (HttpMethod, URL, Encodable?) async -> Result<Data, Error>
    
    enum HttpMethod: String {
        case post = "POST"
        case put = "PUT"
        case get = "GET"
        case delete = "DELETE"
    }
    
    enum Error: LocalizedError {
        case failure
        
        var errorDescription: String? {
            switch self {
            case .failure:
                "Unable to process request"
            }
        }
    }
}

extension APIClient: DependencyKey {
    static let liveValue = Self { httpMethod, url, body in
        @Dependency(\.urlSession) var urlSession
        @Dependency(\.authManager) var authManager
        
        do {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = httpMethod.rawValue
            
            if let token = authManager.token {
                request.setValue(token, forHTTPHeaderField: "Authorization")
            }
            
            if let body {
                request.httpBody = try encoder.encode(body)
            }
            
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                return .failure(.failure)
            }
              
            return .success(data)
        } catch {
            return .failure(.failure)
        }
    }
    
    static let failureValue = Self { _, _, _ in
        return .failure(.failure)
    }
    
    static let loginResponseValue = Self { _, _, _ in
        return .success(Data(jsonFile: JSONFile.login.rawValue))
    }
    
    static let watchlistsResponseValue = Self { _, _, _ in
        return .success(Data(jsonFile: JSONFile.watchlists.rawValue))
    }
    
    static let watchlistResponseValue = Self { _, _, _ in
        return .success(Data(jsonFile: JSONFile.watchlist.rawValue))
    }
    
    static let symbolsResponseValue = Self { _, _, _ in
        return .success(Data(jsonFile: JSONFile.symbols.rawValue))
    }
    
    static let marketDataResponseValue = Self { _, _, _ in
        return .success(Data(jsonFile: JSONFile.marketData.rawValue))
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
