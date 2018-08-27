
//
//  JSONStringTests.swift
//  RusTaxiTests
//
//  Created by Danil Detkin on 27/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import XCTest

@testable import RusTaxi

class JSONStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_1() {
//			{\"Phone\":\"+79999999999\",\"FIO\":\"\",\"Phone_no_prefix\":\"9999999\",\"Prefix\":\"+9\"}
			let parmaters = ["Phone": "1"]
			XCTAssertEqual(JSONString.from(parmaters), "{\"Phone\":\"1\"}")
    }
	
	func test_2() {
		let parmaters = ["Phone": "+79999999999", "FIO": "", "Phone_no_prefix": "9999999", "Prefix": "+9"]
		XCTAssertEqual(JSONString.from(parmaters), "{\"Phone\":\"+79999999999\",\"FIO\":\"\",\"Phone_no_prefix\":\"9999999\",\"Prefix\":\"+9\"}")
	}

}
