//  TIRest.swift
//
//
//  Created by Alexander Ivlev on 23.10.2021.
//

import Foundation
import Combine

typealias QueryItem = (name: String, value: String?)
typealias Query = [QueryItem]

extension BrokerAccountId {
    var query: Query {
        switch self {
        case .tinkoff: return []
        case .id(let accountId): return [("brokerAccountId", accountId)]
        }
    }
}

/// Класс позволяет отправлять запросы на сервер.
public class TIRest {
    public enum Server {
        case sandbox
        case investor
    }

    private let token: String
    private let server: Server
    private let urlSession: URLSession

    public init(token: String, server: Server) {
        self.token = token
        self.server = server

        self.urlSession = URLSession.shared
    }

    func post<Body: Codable, Result: Codable>(path: String,
                                                     body: Body?,
                                                     query: Query = []) -> AnyPublisher<Result, Error> {
        do {
            let bodyData = try body.flatMap { try JSONEncoder().encode($0) }
            return request(method: "POST", path: path, body: bodyData, query: query)
                    .decode(type: Result.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
        } catch {
            return Fail(outputType: Result.self, failure: error).eraseToAnyPublisher()
        }
    }

    func get<Result: Codable>(path: String, query: Query = []) -> AnyPublisher<Result, Error> {
        return request(method: "GET", path: path, query: query)
            .decode(type: Result.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func request(method: String,
                 path: String,
                 body: Data? = nil,
                 query: Query = []) -> AnyPublisher<Data, Error> {
        let url = server.url.appendingPathComponent(path)
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError()
        }
        if !query.isEmpty {
            func escape(_ str: String) -> String {
                var characterSet = CharacterSet.urlPathAllowed
                characterSet.insert(charactersIn: "-._~")
                return str.addingPercentEncoding(withAllowedCharacters: characterSet) ?? str
            }

            urlComponents.queryItems = query.map {
                URLQueryItem(name: escape($0.name), value: $0.value.flatMap { escape($0) })
            }
        }
        guard var urlRequest = urlComponents.url.flatMap({ URLRequest(url: $0) }) else {
            fatalError()
        }

        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("REST: send \(method) request \(urlRequest.url!.absoluteString)")
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("REST: fail receive data from \(url.absoluteString)")
                    throw URLError(.badServerResponse)
                }
                print("REST: receive data from \(url.absoluteString)")
                return element.data
            }.eraseToAnyPublisher()
    }
}

extension TIRest.Server {
    var url: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://api-invest.tinkoff.ru/openapi/sandbox/")!
        case .investor:
            return URL(string: "https://api-invest.tinkoff.ru/openapi/")!
        }

    }
}
