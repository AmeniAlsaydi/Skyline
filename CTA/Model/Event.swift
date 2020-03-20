//
//  Event.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation


struct EventSearch: Codable {
    let embedded: EmbeddedSearch?
    let page: PageInfo
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct PageInfo: Codable {
    let totalElements: Int
}

struct EmbeddedSearch: Codable {
    let events: [Event]
}

struct Event: Codable {
    let name: String
    let type: String
    let id: String
    let url: String
    let images: [Image]
    let dates: DateInfo
    let priceRanges: [PriceRange]?
}

struct PriceRange: Codable {
    let type: String
    let currency: String
    let min: Double
    let max: Double
}
struct Image: Codable {
    let url: String
}

struct DateInfo: Codable {
    let start: StartInfo
}

struct StartInfo: Codable {
    let dateTime: String
}
