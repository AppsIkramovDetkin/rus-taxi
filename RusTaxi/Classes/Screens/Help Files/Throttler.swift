//
//  Extensions+Selector.swift
//  RusTaxi
//
//  Created by Danil Detkin on 19/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class Throttler: NSObject {
	static let shared = Throttler()
	private var completion: VoidClosure?
	
	func throttle(time: Time, closure: @escaping VoidClosure) {
		let timeInterval = time.seconds
		self.completion = closure
		let selector = #selector(throttleSelect)
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
		perform(selector, with: nil, afterDelay: timeInterval)
	}
	
	@objc private func throttleSelect() {
		completion?()
	}
}
