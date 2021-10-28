//
//  Money.swift
//  
//
//  Created by Alexander Ivlev on 28.10.2021.
//

public struct SandboxSetCurrencyBalanceRequest: Codable {
    public let balance: Double
    public let currency: Currency

    public init(balance: Double, currency: Currency) {
        self.balance = balance
        self.currency = currency
    }
}

public struct MoneyAmount: Codable {
    public let value: Double
    public let currency: Currency
}
