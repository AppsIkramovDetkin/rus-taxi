//
//  Extensions.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

extension UIView {
	func underline() {
		let line = UIView()
		line.backgroundColor = TaxiColor.gray
		line.translatesAutoresizingMaskIntoConstraints = false
		let top = NSLayoutConstraint(item: line, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 1)
		let height = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
		let width = NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
		let centerX = NSLayoutConstraint(item: line, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		let tag = self.tag * 74
		line.tag = tag
		
		if superview?.viewWithTag(tag) == nil {
			superview?.addSubview(line)
			superview?.addConstraints([top, height, width, centerX])
		}
	}
}
