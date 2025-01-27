//
//  LoginRequest.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

struct LoginRequest: Codable {
    let username: String
    let password: String
    let rememberMe: Bool = false

    enum CodingKeys: String, CodingKey {
        case username = "login"
        case password
        case rememberMe = "remember-me"
    }
}
