//
//  StringExt.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/17/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

// check if the search is an int (postal code vs city)

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
