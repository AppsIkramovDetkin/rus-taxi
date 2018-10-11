//
//  Extension+UIEdgeInsets.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	static func insets(with constant: CGFloat) -> UIEdgeInsets {
		return UIEdgeInsetsMake(constant, constant, constant, constant)
	}
}
