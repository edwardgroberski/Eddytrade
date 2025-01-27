//
//  AuthManagerTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/24/25.
//

import Dependencies
import Testing
@testable import Eddietrade

struct AuthManagerTests {

    @Test("Call login and receive true for logged in")
    func validLogin() async {
        await withDependencies {
            $0.loginService = .testValue
        } operation: {
            let manager = AuthManager()
            let loggedIn = await manager.login(username: "", password: "")
            #expect(loggedIn)
            #expect(manager.isAuthenticated)
            #expect(manager.token == "token")
        }
    }
    
    @Test("Call login and receive false")
    func failureLogin() async throws {
        await withDependencies {
            $0.loginService = .failureValue
        } operation: {
            let manager = AuthManager()
            let loggedIn = await manager.login(username: "", password: "")
            #expect(!loggedIn)
            #expect(!manager.isAuthenticated)
            #expect(manager.token == nil)
        }
    }
}
