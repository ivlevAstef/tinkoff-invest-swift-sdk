//
//  MarketInstrumentList.swift
//  
//
//  Created by Alexander Ivlev on 29.10.2021.
//

import Foundation

public struct MarketInstrumentList: Codable {
    public struct MarketInstrument: Codable {
        public let figi: FIGI
        public let ticket: String
        public let lot: Int
        public let name: String
        public let type: InstrumentType
        public let currency: Currency?
        /// Шаг цены
        public let minPriceIncrement: Double?
        /// Минимальное число инструментов для покупки должно быть не меньше, чем размер лота х количество лотов
        public let minQuantity: Int?
        public let isin: String?
    }

    public let total: Int
    public let instruments: [MarketInstrument]
}
