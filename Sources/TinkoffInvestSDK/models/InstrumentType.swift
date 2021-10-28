//
//  InstrumentType.swift
//  
//
//  Created by Alexander Ivlev on 29.10.2021.
//

import Foundation

public enum InstrumentType: String, Codable {
    case stock = "Stock"
    case currency = "Currency"
    case bond = "Bond"
    case etf = "Etf"
}
