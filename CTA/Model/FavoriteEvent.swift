//
//  FavoriteEvent.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct FavoriteEvent {
    let name: String
    let type: String
    let id: String
    let url: String
    let imageUrl: String
    let favoritedDate: Timestamp
}


extension FavoriteEvent {
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? "no name"
        self.favoritedDate = dictionary["favoritedDate"] as? Timestamp ?? Timestamp(date: Date())
        self.type = dictionary["type"] as? String ?? "no type"
        self.id = dictionary["id"] as? String ?? "no id"
        self.url = dictionary["url"] as? String ?? "no url"
        self.imageUrl = dictionary["imageUrl"] as? String ?? "no imageUrl"
    }
}
