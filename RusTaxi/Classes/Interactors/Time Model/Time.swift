//
//  Time.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

//!! add unit tests
class Time {
	var seconds: TimeInterval
	
	static var zero: Time {
		return Time(0)
	}
	
	func seconds(_ value: TimeInterval) -> Time {
		return Time(self.seconds + value)
	}
	
	func minutes(_ value: TimeInterval) -> Time {
		return Time(self.seconds + value * 60)
	}
	
	func hours(_ value: TimeInterval) -> Time {
		return Time(self.seconds + value * 60 * 60)
	}
	
	func days(_ value: TimeInterval) -> Time {
		return Time(self.seconds + value * 60 * 60 * 24)
	}
	
	func weeks(_ value: TimeInterval) -> Time {
		return Time(self.seconds + value * 60 * 60 * 24 * 7)
	}
	
	init(_ seconds: TimeInterval = 0) {
		self.seconds = seconds
	}
}
