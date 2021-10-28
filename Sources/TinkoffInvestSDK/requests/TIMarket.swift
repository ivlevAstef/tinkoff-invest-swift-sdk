//
//  TIMarket.swift
//  
//
//  Created by Alexander Ivlev on 29.10.2021.
//

import Foundation
import Combine

public final class TIMarket {
    private let rest: TIRest

    public init(rest: TIRest) {
        self.rest = rest
    }

    public func stocks() -> AnyPublisher<MarketInstrumentList, Error> {
        return rest.get(path: "/market/stocks")
            .map { (response: Response<MarketInstrumentList>) -> MarketInstrumentList in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func bonds() -> AnyPublisher<MarketInstrumentList, Error> {
        return rest.get(path: "/market/bonds")
            .map { (response: Response<MarketInstrumentList>) -> MarketInstrumentList in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func etfs() -> AnyPublisher<MarketInstrumentList, Error> {
        return rest.get(path: "/market/etfs")
            .map { (response: Response<MarketInstrumentList>) -> MarketInstrumentList in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func currencies() -> AnyPublisher<MarketInstrumentList, Error> {
        return rest.get(path: "/market/currencies")
            .map { (response: Response<MarketInstrumentList>) -> MarketInstrumentList in
                return response.payload
            }.eraseToAnyPublisher()
    }

    /// стакан (глубина от 1 до 20)
    public func candles(figi: FIGI, from: Date, to: Date, interval: CandleResolution) -> AnyPublisher<Candles, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZZZZZ"
        return rest.get(path: "/market/candles", query: [("figi", figi),
                                                         ("from", dateFormatter.string(from: from)),
                                                         ("to", dateFormatter.string(from: to)),
                                                         ("interval", interval.rawValue)])
            .map { (response: Response<Candles>) -> Candles in
                return response.payload
            }.eraseToAnyPublisher()
    }

    /// стакан (глубина от 1 до 20)
    public func orderbook(figi: FIGI, depth: Int) -> AnyPublisher<Orderbook, Error> {
        return rest.get(path: "/market/currencies", query: [("figi", figi), ("depth", "\(depth)")])
            .map { (response: Response<Orderbook>) -> Orderbook in
                return response.payload
            }.eraseToAnyPublisher()
    }
}
