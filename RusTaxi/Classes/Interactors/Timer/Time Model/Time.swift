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
		return Time(self.seconds(60).seconds)
	}
	
	func hours(_ value: TimeInterval) -> Time {
		return Time(self.minutes(60).seconds)
	}
	
	func days(_ value: TimeInterval) -> Time {
		return Time(self.hours(24).seconds)
	}
	
	func weeks(_ value: TimeInterval) -> Time {
		return Time(self.days(7).seconds)
	}
	
	init(_ seconds: TimeInterval = 0) {
		self.seconds = seconds
	}
}
