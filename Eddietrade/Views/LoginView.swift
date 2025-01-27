//
//  LoginView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            title
            usernameTextField
            passwordTextField
            loginButton
        }
        .padding(24)
        .alert(model: $viewModel.alert)
        .loadingOverlay(isLoading: Binding(get: {
            viewModel.isLoading
        }, set: { _ in
        }))
    }
    
    @ViewBuilder
    private var title: some View {
        VStack {
            Text("🍒eddytrade")
                .font(.custom("Times New Roman Bold", size: 50))
                .bold()
        }
    }
    
    private var usernameTextField: some View {
        TextField(text: $viewModel.username, label: {
            Text("Username")
        })
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
    
    private var passwordTextField: some View {
        SecureField(text: $viewModel.password, label: {
            Text("Password")
        })
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await viewModel.login()
            }
        } label: {
            Text("Login")
            .tint(.white)
        }
        .padding()
        .background(Color.gray.opacity(0.8))
        .cornerRadius(8)
    }
}

#Preview {
    LoginView()
}
