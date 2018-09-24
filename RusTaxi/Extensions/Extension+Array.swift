//
//  SpecifiedTypeExtension.swift
//  RusTaxi
//
//  Created by Danil Detkin on 20/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

extension Array where Element == Address {
	mutating func first(to value: Address) {
		self[0] = value
	}
}
