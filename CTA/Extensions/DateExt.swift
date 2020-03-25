//
//  DateExt.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/20/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

extension String {
    public func convertToDate() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self)!
        return date
    }
}


extension Date {
    public func convertToString(_ format: String = "EEEE, MMM d, h:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self) // self is that date object itself
        
    }
}
