//
//  Response.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

struct Response<T: Decodable>: Decodable {
    let data: T
}
