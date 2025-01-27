//
//  WatchlistService.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies

struct WatchlistService: Sendable {
    var getWatchlists: @Sendable () async throws -> [Watchlist]
    var createWatchlist: @Sendable (Watchlist) async throws -> Watchlist
    var updateWatchlist: @Sendable (Watchlist) async throws -> Watchlist
    var deleteWatchlist: @Sendable (String) async throws -> Void
    
    enum API: String, Codable {
        case watchlists = "https://api.cert.tastyworks.com/watchlists"
    }
    
    private static func request<T: Codable>(httpMethod: APIClient.HttpMethod,
                                            name: String? = nil,
                                            watchlist: Watchlist? = nil) async throws -> T {
        var url: URL
        if let name {
            url = try WatchlistService.nameParameterUrl(name: name)
        } else {
            url = URL(string: API.watchlists.rawValue)!
        }
        
        @Dependency(\.apiClient) var apiClient
        let result = await apiClient.fetch(httpMethod, url, watchlist)
        
        switch result {
        case .success(let data):
            let response = try JSONDecoder().decode(Response<T>.self, from: data)
            return response.data
        case .failure(let error):
            throw error
        }
    }
    
    private static func nameParameterUrl(name: String) throws -> URL {
        var urlComponents = URLComponents(string: API.watchlists.rawValue)!
        urlComponents.path = "/watchlists/\(name)"
        
        guard let url = urlComponents.url else {
            throw APIClient.Error.failure
        }
        
        return url
    }
}

extension WatchlistService: DependencyKey {
    static var liveValue: WatchlistService {
        return Self(
            getWatchlists: {
                let watchlists: ItemsResponse<Watchlist> = try await WatchlistService.request(httpMethod: .get)
                return watchlists.items
            },
            createWatchlist: { watchList in
                let watchlist: Watchlist = try await WatchlistService.request(httpMethod: .post, watchlist: watchList)
                return watchlist
            },
            updateWatchlist: { watchlist in
                let watchlist: Watchlist = try await WatchlistService.request(httpMethod: .put, name: watchlist.name, watchlist: watchlist)
                return watchlist
            },
            deleteWatchlist: { name in
                let _: Watchlist = try await WatchlistService.request(httpMethod: .delete, name: name)
                return
            }
        )
    }
    
    static var testValue: WatchlistService {
        return Self(
            getWatchlists: {
                return [watchList1, watchList2]
            },
            createWatchlist: { watchlist in
                return watchList1
            },
            updateWatchlist: { watchlist in
                return watchList1
            },
            deleteWatchlist: { name in
                return
            }
        )
    }
    
    static var previewValue: WatchlistService {
        return Self(
            getWatchlists: {
                return [watchList1, watchList2]
            },
            createWatchlist: { watchlist in
                return watchList1
            },
            updateWatchlist: { watchlist in
                return watchList1
            },
            deleteWatchlist: { name in
                return
            }
        )
    }
    
    static var failureValue: WatchlistService {
        return Self(
            getWatchlists: {
                throw APIClient.Error.failure
            },
            createWatchlist: { watchlist in
                throw APIClient.Error.failure
            },
            updateWatchlist: { watchlist in
                throw APIClient.Error.failure
            },
            deleteWatchlist: { _ in
                throw APIClient.Error.failure
            }
        )
    }
}

extension DependencyValues {
    var watchlistService: WatchlistService {
        get { self[WatchlistService.self] }
        set { self[WatchlistService.self] = newValue }
    }
}
