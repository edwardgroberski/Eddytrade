//
//  LoginResponse.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
    let sessionExpiration: String
    let sessionToken: String

    enum CodingKeys: String, CodingKey {
        case user
        case sessionExpiration = "session-expiration"
        case sessionToken = "session-token"
    }
    
    struct User: Codable {
        let email: String
        let externalID: String
        let isConfirmed: Bool
        let username: String

        enum CodingKeys: String, CodingKey {
            case email
            case externalID = "external-id"
            case isConfirmed = "is-confirmed"
            case username
        }
    }
}
