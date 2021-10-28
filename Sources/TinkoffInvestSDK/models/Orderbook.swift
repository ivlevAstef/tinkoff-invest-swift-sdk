//
//  Orderbook.swift
//  
//
//  Created by Alexander Ivlev on 29.10.2021.
//

import Foundation

public struct Orderbook: Codable {
    public struct OrderResponse: Codable {
        public let price: Double
        public let quantity: Int
    }
    public enum TradeStatus: String, Codable {
        case normalTrading = "NormalTrading"
        case notAvailableForTrading = "NotAvailableForTrading"
    }
    public let figi: FIGI
    public let depth: Int
    public let bids: [OrderResponse]
    public let asks: [OrderResponse]
    public let tradeStatus: TradeStatus
    /// Шаг цены
    public let minPriceIncrement: Double
    /// Номинал для облигаций
    public let faceValue: Double?
    public let lastPrice: Double?
    public let closePrice: Double?
    /// Верхняя граница цены
    public let limitUp: Double?
    /// Нижняя граница цены
    public let limitDown: Double?
}
