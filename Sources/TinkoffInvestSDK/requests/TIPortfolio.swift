//
//  TIPortfolio.swift
//  
//
//  Created by Alexander Ivlev on 29.10.2021.
//


import Foundation
import Combine

public final class TIPortfolio {
    private let rest: TIRest

    public init(rest: TIRest) {
        self.rest = rest
    }

    public func fetch(accountId: BrokerAccountId) -> AnyPublisher<Portfolio, Error> {
        return rest.get(path: "/portfolio", query: accountId.query)
            .map { (response: Response<Portfolio>) -> Portfolio in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func currencies(accountId: BrokerAccountId) -> AnyPublisher<CurrencyPositions, Error> {
        return rest.get(path: "/portfolio/currencies", query: accountId.query)
            .map { (response: Response<CurrencyPositions>) -> CurrencyPositions in
                return response.payload
            }.eraseToAnyPublisher()
    }
}

