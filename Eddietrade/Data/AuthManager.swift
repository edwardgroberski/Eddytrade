//
//  AuthManager.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import Foundation
import Dependencies


protocol AuthManagerProtocol: Sendable {
    var token: String? { get }
    var isAuthenticated: Bool { get }
    func login(username: String, password: String) async -> Bool
}

@Observable
final class AuthManager: AuthManagerProtocol, @unchecked Sendable {
    private(set) var token: String?
    var isAuthenticated: Bool {
        return token != nil
    }
    
    func login(username: String, password: String) async -> Bool {
        @Dependency(\.loginService) var loginService
        
        do {
            let token = try await loginService.login(username, password)
            print("token = \(token)")
            
            self.token = token
            
            return true
        } catch {
            return false
        }
    }
}

enum AuthManagerKey: DependencyKey {
    static let liveValue: AuthManagerProtocol = AuthManager()
    static let authenticatedValue: AuthManagerProtocol = MockAuthManager(isAuthenticated: true)
    static let notAuthenticatedValue: AuthManagerProtocol = MockAuthManager(isAuthenticated: false)
}

extension DependencyValues {
    var authManager: AuthManagerProtocol {
        get { self[AuthManagerKey.self] }
        set { self[AuthManagerKey.self] = newValue }
    }
}

final class MockAuthManager: AuthManagerProtocol, @unchecked Sendable {
    var token: String?
    var isAuthenticated: Bool
    
    init(token: String? = nil, isAuthenticated: Bool) {
        self.token = token
        self.isAuthenticated = isAuthenticated
    }
    
    func login(username: String, password: String) async -> Bool {
        return isAuthenticated
    }
}
