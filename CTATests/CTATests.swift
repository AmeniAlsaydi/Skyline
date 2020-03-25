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
@testable import CTA

class CTATests: XCTestCase {

    func testEventApiClient() {
        
        let expctedName = "Hamilton (NY)"
        let city = "new york"
        let exp = XCTestExpectation(description: "events found")
        
        
        ApiClient.getEvents(searchQuery: city) { (result) in
            switch result {
            case .failure(let appError):
                 XCTFail("\(appError)")
            case .success(let search):
                let eventName = search.embedded?.events.first?.name
                XCTAssertEqual(eventName, expctedName)
                exp.fulfill()
            }
        }
       wait(for:[exp], timeout: 5.0)
    }
    
    
    
    func testArtApiClient() {
        let expctedTitle = "De vernietiging van de Spaanse galeien voor de Vlaamse kust, 1602"
        let search = "rem"
        let exp = XCTestExpectation(description: "art objects found")
        
        ApiClient.getArtObjects(searchQuery: search) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("\(appError)")
            case .success(let arts):
                let artTitle = arts.first?.title
                XCTAssertEqual(artTitle, expctedTitle)
                exp.fulfill()
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
}
