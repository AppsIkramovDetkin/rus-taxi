//
//  Toast.swift
//  RusTaxi
//
//  Created by Danil Detkin on 20/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class Toast {
	private static var isShowed: Bool {
		return !toastView.isHidden
	}
	
	private static let duration = 0.25
	
	static var toastView: ToastView = {
		let toast = ToastView.loadFromNib()
		toast.isHidden = true
		return toast
	}()
	
	static var view: UIView {
		return UIApplication.shared.keyWindow ?? (UIApplication.shared.delegate as? AppDelegate)?.window ?? UIView()
	}
	
	static func show(with text: String, completion: VoidClosure? = nil, timeline: Time? = nil) {
		toastView.set(text: text)
		toastView.buttonClicked = {
			hide()
			completion?()
		}
		
		guard isShowed == false else {
			return
		}
		toastView.isHidden = false
		toastView.center.x = view.center.x
		toastView.frame.origin.y = view.frame.maxY
		view.addSubview(toastView)

		UIView.animate(withDuration: duration) {
			toastView.frame.origin.y = view.frame.maxY - toastView.frame.size.height
		}
		
		if let time = timeline {
			delay(delay: time.seconds) {
				hide()
			}
		}
	}
	
	static func hide() {
		guard isShowed else {
			return
		}
		
		UIView.animate(withDuration: duration, animations: {
			toastView.frame.origin.y = view.frame.maxY
		}) { (true) in
			toastView.isHidden = true
		}
	}
}
