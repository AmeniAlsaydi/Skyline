//
//  FavoriteArt.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/18/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct FavoriteArt {
    let title: String
    let id: String
    let imageUrl: String
    let favoritedDate: Timestamp
}


extension FavoriteArt {
    init(_ dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? "no title"
        self.id = dictionary["id"] as? String ?? "no id"
        self.imageUrl = dictionary["imageUrl"] as? String ?? "no image url"
         self.favoritedDate = dictionary["favoritedDate"] as? Timestamp ?? Timestamp(date: Date())
    }
    
}
