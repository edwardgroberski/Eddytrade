//
//  EddietradeTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/24/25.
//

import Dependencies
import Testing
@testable import Eddietrade

struct LoginServiceTests {

    @Test("Call login and receive valid token")
    func validLogin() async throws {
        let service = withDependencies {
            $0.apiClient = .loginResponseValue
        } operation: {
            LoginService.liveValue
        }
        let token = try await service.login("", "")
        #expect(token == "token")
    }
    
    
    @Test("Call login and receive error")
    func failureLogin() async throws {
        let service = withDependencies {
            $0.apiClient = .failureValue
        } operation: {
            LoginService.liveValue
        }
        await #expect(throws: (any Error).self) {
            try await service.login("", "")
        }
    }
}
