//
//  User.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let createdDate: Timestamp
    let email: String
    let experience: String
    let userid: String
    let photoUrl: String
    let displayName: String
}

extension User {
    
    init(_ dictionary: [String: Any]) {
        self.createdDate = dictionary["createdDate"] as? Timestamp ?? Timestamp(date: Date())
        self.email = dictionary["email"] as? String ?? "no email"
        self.experience = dictionary["experience"] as? String ?? "no experience"
        self.userid = dictionary["userid"] as? String ?? "no id"
        self.photoUrl = dictionary["photoUrl"] as? String ?? "no photoUrl"
        self.displayName = dictionary["photoUrl"] as? String ?? "No Name"
    }
}
