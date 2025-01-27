//
//  LoginViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import Foundation
import Dependencies

@MainActor
@Observable
class LoginViewModel {
    private(set) var state: State = .notAuthenticated
    var isLoading: Bool { state == .loading}
    
    var username = ""
    var password = ""
    
    var alert: AlertViewModel?
    
    func login() async {
        guard !username.isEmpty && !password.isEmpty else {
            // Show alert
            showAlert(title: "Input Error", message: "Please enter username and password")
            return
        }
        
        setLoadingState()
        
        @Dependency(\.authManager) var authManager
        
        let authticated = await authManager.login(username: username, password: password)
        
        if (authticated) {
            setAuthenticatedState()
        } else {
            setNotAuthenticatedState()
            showAlert(title: "Login Error", message: "Could not login")
        }
    }
}

extension LoginViewModel{
    private func setNotAuthenticatedState() {
        state = .notAuthenticated
    }
    
    private func setLoadingState() {
        state = .loading
    }
    
    private func setAuthenticatedState() {
        state = .authenticated
    }
    
    private func showAlert(title: String, message: String) {
        alert = .init(title: title, message: message)
    }
}

extension LoginViewModel{
    enum State: Equatable {
        case notAuthenticated
        case loading
        case authenticated
    }
}
