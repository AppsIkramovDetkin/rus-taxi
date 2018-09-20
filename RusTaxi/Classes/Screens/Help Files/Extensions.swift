//
//  Extensions.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import CoreLocation.CLLocation

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

extension UIView {
	static func by(nibName: String) -> UIView {
		return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)![0] as! UIView
	}
}


extension NSLayoutConstraint {
	static func quadroAspect(on view: UIView) -> NSLayoutConstraint {
		return NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
	}
	static func contraints(withNewVisualFormat vf: String, dict: [String: Any]) -> [NSLayoutConstraint] {
		let separatedArray = vf.split(separator: ",")
		switch separatedArray.count {
		case 1: return NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[0])", options: [], metrics: nil, views: dict)
		case 2: return NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[0])", options: [], metrics: nil, views: dict) + NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[1])", options: [], metrics: nil, views: dict)
		default: return NSLayoutConstraint.constraints(withVisualFormat: "\(separatedArray[0])", options: [], metrics: nil, views: dict)
		}
	}
}

extension Optional where Wrapped == String {
	var value: String {
		return self ?? ""
	}
}

extension UIView {
	
	func dropShadow(scale: Bool = true) {
		layer.masksToBounds = false
		layer.shadowColor = TaxiColor.black.cgColor
		layer.shadowOpacity = 6
		layer.shadowOffset = CGSize(width: -1, height: 1)
		layer.shadowRadius = 3
		
		layer.shadowPath = UIBezierPath(rect: bounds).cgPath
		layer.shouldRasterize = true
		layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
}

extension NSLayoutConstraint {
	static func centerY(for sview: UIView, to view: UIView) -> NSLayoutConstraint {
		return NSLayoutConstraint.init(item: sview, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
	}
	
	static func centerX(for sview: UIView, to view: UIView) -> NSLayoutConstraint {
		return NSLayoutConstraint.init(item: sview, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
	}
	
	static func set(size: CGSize, for view: UIView) -> [NSLayoutConstraint] {
		return [NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.height)] + [NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.width)]
	}
}

extension CLLocation {
	static func from(coordinate: CLLocationCoordinate2D) -> CLLocation {
		return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
}
