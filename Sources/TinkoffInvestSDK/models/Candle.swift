//
//  Candle.swift
//  
//
//  Created by Alexander Ivlev on 29.10.2021.
//

import Foundation

/// Или по другому еще interval
public enum CandleResolution: String, Codable {
    /// Не больше дня
    case min1 = "1min"
    /// Не больше дня
    case min2 = "2min"
    /// Не больше дня
    case min3 = "3min"
    /// Не больше дня
    case min5 = "5min"
    /// Не больше дня
    case min10 = "10min"
    /// Не больше дня
    case min15 = "15min"
    /// Не больше дня
    case min30 = "30min"
    /// Не больше 7 дней (недели)
    case hour = "hour"
    /// Не больше года
    case day = "day"
    /// Не больше 2 лет
    case week = "week"
    /// Не больше 10 лет
    case month = "month"
}

public struct Candles: Codable {
    public struct Candle: Codable {
        public let figi: FIGI
        public let interval: CandleResolution
        public let open: Double
        public let close: Double
        public let high: Double
        public let low: Double
        public let volume: Int
        /// 2019-08-19T18:38:33+03:00 == "yyyy-MM-dd'T'hh:mm:ssZZZZZ"
        public let time: String

        enum CodingKeys: String, CodingKey {
            case figi
            case interval
            case open = "o"
            case close = "c"
            case high = "h"
            case low = "l"
            case volume = "v"
            case time
        }
    }
    public let figi: FIGI
    public let interval: CandleResolution
    public let candles: [Candle]
}
