//
//  Event.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation


struct EventSearch: Codable {
    let embedded: EmbeddedSearch
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
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
