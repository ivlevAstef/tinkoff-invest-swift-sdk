//
//  TISandbox.swift
//  
//
//  Created by Alexander Ivlev on 23.10.2021.
//

import Foundation
import Combine

public final class TISandbox {
    public enum AccountType {
        case tinkoff
        case tinkoffIis
    }

    private struct RegisterRequest: Codable {
        let brokerAccountType: String

        init(type: TISandbox.AccountType) {
            switch type {
            case .tinkoff: brokerAccountType = "Tinkoff"
            case .tinkoffIis: brokerAccountType = "TinkoffIis"
            }
        }
    }

    private struct RegisterPayload: Codable {
        let brokerAccountType: String
        let brokerAccountId: BrokerAccountId
    }

    private let rest: TIRest

    public init(rest: TIRest) {
        self.rest = rest
    }

    public func register(accountType: AccountType) -> AnyPublisher<BrokerAccountId, Error> {
        return rest.post(path: "/register", body: RegisterRequest(type: accountType))
            .map { (response: Response<RegisterPayload>) -> BrokerAccountId in
                return response.payload.brokerAccountId
            }.eraseToAnyPublisher()
    }

    public func remove(accountId: BrokerAccountId) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "/remove", body: nil as Optional<Empty>, query: [("brokerAccountId", accountId)])
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func clearPositions(accountId: BrokerAccountId) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "/clear", body: nil as Optional<Empty>, query: [("brokerAccountId", accountId)])
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func setBalance(accountId: BrokerAccountId, money: SandboxSetCurrencyBalanceRequest) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "/currencies/balance", body: money, query: [("brokerAccountId", accountId)])
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func setPosition(accountId: BrokerAccountId, position: SandboxSetPositionBalanceRequest) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "/sandbox/positions/balance", body: position, query: [("brokerAccountId", accountId)])
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }
}
