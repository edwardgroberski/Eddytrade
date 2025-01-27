//
//  LoginService.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import Foundation
import Dependencies

struct LoginService: Sendable {
    var login: @Sendable (String, String) async throws -> String
    
    enum API: String, Codable {
        case sessions = "https://api.cert.tastyworks.com/sessions"
    }
}

extension LoginService: DependencyKey {
    static var liveValue: LoginService {
        @Dependency(\.apiClient) var apiClient
        
        return Self { username, password in
            let url = URL(string: API.sessions.rawValue)!
            let body = LoginRequest(username: username, password: password)
            let result = await apiClient.fetch(.post, url, body)
            
            switch result {
            case .success(let data):
                let response = try JSONDecoder().decode(Response<LoginResponse>.self, from: data)
                return response.data.sessionToken
            case .failure(let error):
                throw error
            }
        }
    }
    
    static var testValue: LoginService {
        return Self { _, _ in
            return "token"
        }
    }
    
    static var failureValue: LoginService {
        return Self { _, _ in
            throw APIClient.Error.failure
        }
    }
}

extension DependencyValues {
    var loginService: LoginService {
        get { self[LoginService.self] }
        set { self[LoginService.self] = newValue }
    }
}
