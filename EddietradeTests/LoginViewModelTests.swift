//
//  LoginViewModelTests.swift
//  EddietradeTests
//
//  Created by Edward Groberski on 1/24/25.
//

import Dependencies
import Testing
@testable import Eddietrade

struct LoginViewModelTests {

    @MainActor
    @Test("Call login with valid credientials and state is authenticated")
    func validLogin() async {
        await withDependencies {
            $0.authManager = AuthManagerKey.authenticatedValue
        } operation: {
            let viewModel = LoginViewModel()
            viewModel.username = "test"
            viewModel.password = "test"
            await viewModel.login()
            #expect(viewModel.state == .authenticated)
        }
    }
    
    @MainActor
    @Test("Call login with invalid credientials and state is not authenticated")
    func invalidCredsLogin() async {
        await withDependencies {
            $0.authManager = AuthManagerKey.authenticatedValue
        } operation: {
            let viewModel = LoginViewModel()
            viewModel.username = ""
            viewModel.password = "test"
            await viewModel.login()
            #expect(viewModel.state == .notAuthenticated)
            #expect(viewModel.alert != nil)
        }
    }
    
    @MainActor
    @Test("Call login with valid credientials, auth manager fails, and state is not authenticated")
    func authManagerFailureLogin() async {
        await withDependencies {
            $0.authManager = AuthManagerKey.notAuthenticatedValue
        } operation: {
            let viewModel = LoginViewModel()
            viewModel.username = "test"
            viewModel.password = "test"
            await viewModel.login()
            #expect(viewModel.state == .notAuthenticated)
            #expect(viewModel.alert != nil)
        }
    }
}
