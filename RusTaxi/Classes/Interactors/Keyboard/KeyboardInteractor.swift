//
//  KeyboardInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 20/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class KeyboardInteractor {
	static let shared = KeyboardInteractor()
	private init() {}
	private(set) var isShowed = false
	
	func subscribe() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowed), name: Notification.Name.UIKeyboardDidShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardHided), name: Notification.Name.UIKeyboardDidHide, object: nil)
	}
	
	@objc private func keyboardShowed() {
		isShowed = true
	}
	
	@objc private func keyboardHided() {
		isShowed = false
	}
	
	func unsubscribe() {
		NotificationCenter.default.removeObserver(self)
	}
}
