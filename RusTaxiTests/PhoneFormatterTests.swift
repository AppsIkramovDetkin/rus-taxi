//
//  PhoneFormatterTests.swift
//  RusTaxiTests
//
//  Created by Danil Detkin on 26/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import XCTest

@testable import RusTaxi

class PhoneFormatterTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testOnlyPlusFormat_1() {
		let phone = "+7(918167-28-10)"
		let newPhone = PhoneFormatterHelper.format(phone, with: .onlyWithPlus)

		XCTAssertEqual(newPhone, "+79181672810")
	}
	
	func testOnlyPlusFormat_2() {
		let phone = "+7(918-167-28-10)"
		let newPhone = PhoneFormatterHelper.format(phone, with: .onlyWithPlus)
		
		XCTAssertEqual(newPhone, "+79181672810")
	}
	
	func testOnlyPlusFormat_3() {
		let phone = "+7(918-167-28-9320990)"
		let newPhone = PhoneFormatterHelper.format(phone, with: .onlyWithPlus)
		
		XCTAssertEqual(newPhone, "+7918167289320990")
	}
	
	func testOnlyPlusFormat_4() {
		let phone = "8(918)167-28-10"
		let newPhone = PhoneFormatterHelper.format(phone, with: .onlyWithPlus)
		
		XCTAssertEqual(newPhone, "+79181672810")
	}
}
