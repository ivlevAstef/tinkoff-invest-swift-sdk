//
//  TIOrders.swift
//  
//
//  Created by Alexander Ivlev on 28.10.2021.
//

import Foundation
import Combine

public final class TIOrders {
    private let rest: TIRest

    public init(rest: TIRest) {
        self.rest = rest
    }

    public func fetch(accountId: BrokerAccountId) -> AnyPublisher<Order, Error> {
        return rest.get(path: "orders", query: accountId.query)
            .map { (response: Response<Order>) -> Order in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func limit(accountId: BrokerAccountId, figi: FIGI, order: LimitOrderRequest) -> AnyPublisher<PlacedOrder, Error> {
        return rest.post(path: "orders/limit-order", body: order, query: accountId.query + [("figi", figi)])
            .map { (response: Response<PlacedOrder>) -> PlacedOrder in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func market(accountId: BrokerAccountId, figi: FIGI, order: MarketOrderRequest) -> AnyPublisher<PlacedOrder, Error> {
        return rest.post(path: "orders/market-order", body: order, query: accountId.query + [("figi", figi)])
            .map { (response: Response<PlacedOrder>) -> PlacedOrder in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func cancel(accountId: BrokerAccountId, orderId: Order.ID) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "orders/cancel", body: nil as Optional<Empty>, query: accountId.query + [("orderId", "\(orderId)")])
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }
}

