//
//  ArtObject.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/17/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation


struct ArtSearch: Codable {
    let artObjects: [ArtObject]
}

struct ArtObject: Codable {
    let links: Links
    let id: String
    let title: String
    let hasImage: Bool
    let webImage: ArtImage?
    
}

struct ArtImage: Codable {
    let url: String?
}

struct Links: Codable {
    //let self: String  // FIX THIS use coding key "self" is causing an issue
    let web: String
}
