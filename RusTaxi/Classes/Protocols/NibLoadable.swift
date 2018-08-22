//
//  NibLoadable.swift
//  RusTaxi
//
//  Created by Danil Detkin on 22/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
	static var nib: UINib { get }
}

public extension NibLoadable {
	static var nib: UINib {
		return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
	}
}

public extension NibLoadable where Self: UIView {
	static func loadFromNib() -> Self {
		guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
			fatalError("The nib \(nib) expected its root view to be of type \(self)")
		}
		return view
	}
}
