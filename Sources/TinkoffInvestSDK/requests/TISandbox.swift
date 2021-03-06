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
        let brokerAccountId: String
    }

    private let rest: TIRest

    public init(rest: TIRest) {
        self.rest = rest
    }

    public func register(accountType: AccountType) -> AnyPublisher<BrokerAccountId, Error> {
        return rest.post(path: "sandbox/register", body: RegisterRequest(type: accountType))
            .map { (response: Response<RegisterPayload>) -> BrokerAccountId in
                return .id(response.payload.brokerAccountId)
            }.eraseToAnyPublisher()
    }

    public func remove(accountId: BrokerAccountId) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "sandbox/remove", body: nil as Optional<Empty>, query: accountId.query)
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func clearPositions(accountId: BrokerAccountId) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "sandbox/clear", body: nil as Optional<Empty>, query: accountId.query)
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func setBalance(accountId: BrokerAccountId, money: SandboxSetCurrencyBalanceRequest) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "sandbox/currencies/balance", body: money, query: accountId.query)
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }

    public func setPosition(accountId: BrokerAccountId, position: SandboxSetPositionBalanceRequest) -> AnyPublisher<Empty, Error> {
        return rest.post(path: "sandbox/positions/balance", body: position, query: accountId.query)
            .map { (response: Response<Empty>) -> Empty in
                return response.payload
            }.eraseToAnyPublisher()
    }
}
