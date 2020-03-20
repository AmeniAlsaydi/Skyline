//
//  ArtDetail.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/19/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct ArtDetailSearch: Codable {
    let artObject: ArtDetail
}

struct ArtDetail: Codable {
    
    let id: String
    let objectNumber: String
    let title: String
    let webImage: ArtImage
    let plaqueDescriptionEnglish: String?
    let principalMaker: String
    let dating: ArtDate
    let principalMakers: [PrincipalMakers]
}

struct ArtDate: Codable {
    let presentingDate: String
}

struct PrincipalMakers: Codable {
    let productionPlaces: [String]
 
}
