//
//  EndlessIndicator.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

@IBDesignable
class EndlessIndicator: UIView {
	var stickView: UIView = UIView()
	private let duration: TimeInterval = 0.4
	private var isNeedToStop = false
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		addStickView()
		stickView.isHidden = false
	}
	
	func startProgressing() {
		isNeedToStop = true
		stickView.isHidden = false
		let newOrigin: CGFloat = {
			if stickView.frame.origin.x > 10 {
				return 0
			} else {
				return frame.maxX - stickView.frame.width
			}
		}()
		UIView.animate(withDuration: duration, animations: {
			self.stickView.frame.origin.x = newOrigin
		}) { (finished) in
			if !self.isNeedToStop {
				self.startProgressing()
			}
		}
	}
	
	func stopProgressing() {
		self.isNeedToStop = true
	}
	
	func addStickView() {
		stickView.frame = CGRect(x: 0, y: 0, width: frame.width * 0.3, height: frame.height)
		stickView.backgroundColor = TaxiColor.taxiOrange
		addSubview(stickView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
