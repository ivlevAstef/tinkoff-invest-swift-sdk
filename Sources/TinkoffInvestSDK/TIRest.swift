//  TIRest.swift
//
//
//  Created by Alexander Ivlev on 23.10.2021.
//

import Foundation
import Combine

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

    public func post<Body: Codable, Result: Codable>(path: String,
                                                     body: Body?,
                                                     query: [(name: String, value: String?)] = []) -> AnyPublisher<Result, Error> {
        do {
            let bodyData = try body.flatMap { try JSONEncoder().encode($0) }
            return request(method: "POST", path: path, body: bodyData, query: query)
                    .decode(type: Result.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
        } catch {
            return Fail(outputType: Result.self, failure: error).eraseToAnyPublisher()
        }
    }

    public func get<Result: Codable>(path: String, query: [(name: String, value: String?)] = []) -> AnyPublisher<Result, Error> {
        return request(method: "GET", path: path, query: query)
            .decode(type: Result.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    public func request(method: String,
                        path: String,
                        body: Data? = nil,
                        query: [(name: String, value: String?)] = []) -> AnyPublisher<Data, Error> {
        let url = server.url.appendingPathComponent(path)
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError()
        }
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.name, value: $0.value) }
        guard var urlRequest = urlComponents.url.flatMap({ URLRequest(url: $0) }) else {
            fatalError()
        }

        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
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
