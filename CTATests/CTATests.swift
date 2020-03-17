//
//  CTATests.swift
//  CTATests
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import XCTest

// which folder do i import ?

//@testable import CTA
@testable import Pods_CTA

class CTATests: XCTestCase {

    func testEventApiClient() {
        
        let expctedName = "Hamilton (NY)"
        let city = "new york"
        let exp = XCTestExpectation(description: "events found")
        
        
        // i dont have access to the eventsApiClient -> cant test 
    }
}
