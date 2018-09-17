//
//  TimerInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

typealias VoidClosure = (() -> Void)
class TimerInteractor {
	private var timer: Timer?
	private var completion: VoidClosure?
	
	func loop(on time: Time, callback: VoidClosure?) {
		self.completion = callback
		
		let selector = #selector(timed)
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: time.seconds, target: self, selector: selector, userInfo: nil, repeats: true)
		timer?.fire()
	}
	
	func stopIfNeeded() {
		timer?.invalidate()
		completion = nil
	}
	
	func clear() {
		stopIfNeeded()
		timer = nil
	}
	
	@objc func timed() {
		self.completion?()
	}
}
