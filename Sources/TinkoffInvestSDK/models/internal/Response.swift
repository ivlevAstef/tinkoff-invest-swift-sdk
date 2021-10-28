//
//  Response.swift
//  
//
//  Created by Alexander Ivlev on 28.10.2021.
//

import Foundation

struct Response<Payload: Codable>: Codable {
    let trackingId: String
    let status: String
    let payload: Payload
}
