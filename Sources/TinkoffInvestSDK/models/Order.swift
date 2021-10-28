//
//  Order.swift
//  
//
//  Created by Alexander Ivlev on 28.10.2021.
//

import Foundation

public struct Order: Codable {
    public typealias ID = String
    public enum Operation: String, Codable {
        case buy = "Buy"
        case sell = "Sell"
    }
    public enum Status: String, Codable {
        case new = "New"
        case partiallyFill = "PartiallyFill"
        case fill = "Fill"
        case cancelled = "Cancelled"
        case replaced = "Replaced"
        case pendingCancel = "PendingCancel"
        case rejected = "Rejected"
        case pendingReplace = "PendingReplace"
        case pendingNew = "PendingNew"
    }
    public enum OrderType: String, Codable {
        case limit = "Limit"
        case market = "Market"
    }

    public let orderId: ID
    public let figi: FIGI
    public let operation: Operation
    public let status: Status
    public let requestedLots: Int
    public let executedLots: Int
    public let type: OrderType
    public let price: Double
}

public struct LimitOrderRequest: Codable {
    public let lots: Int
    public let operation: Order.Operation
    public let price: Double

    public init(lots: Int, operation: Order.Operation, price: Double) {
        self.lots = lots
        self.operation = operation
        self.price = price
    }
}

public struct MarketOrderRequest: Codable {
    public let lots: Int
    public let operation: Order.Operation

    public init(lots: Int, operation: Order.Operation) {
        self.lots = lots
        self.operation = operation
    }
}

public struct PlacedOrder: Codable {
    public let orderId: Order.ID
    public let operation: Order.Operation
    public let status: Order.Status
    public let requestedLots: Int
    public let executedLots: Int
    public let commision: MoneyAmount?

    public let rejectReason: String?
    public let message: String?
}
