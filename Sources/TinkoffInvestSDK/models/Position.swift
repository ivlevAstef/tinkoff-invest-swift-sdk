//
//  Position.swift
//  
//
//  Created by Alexander Ivlev on 28.10.2021.
//

public struct SandboxSetPositionBalanceRequest: Codable {
    public let figi: FIGI
    public let balance: Int

    public init(figi: FIGI, balance: Int) {
        self.figi = figi
        self.balance = balance
    }
}

public struct Position: Codable {
    public let figi: FIGI
    public let name: String
    public let instrumentType: InstrumentType
    public let balance: Double
    public let lots: Int

    public let averagePositionPrice: MoneyAmount?
    public let averagePositionPriceNoNkd: MoneyAmount?
    /// ожидаемая доходность?
    public let expectedYield: MoneyAmount?

    public let ticket: String?
    public let isin: String?
    public let blocked: Double?
}


public struct CurrencyPositions: Codable {
    public struct CurrencyPosition: Codable {
        public let currency: Currency
        public let balance: Double
        public let blocked: Double?
    }
    public let currencies: [CurrencyPosition]
}
