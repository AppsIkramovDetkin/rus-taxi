//
//  Wish.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 14.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class Wish {
	var name: String
	var price: String?
	var isOnWish: Bool = false
	
	init(name: String, price: String? = nil) {
		self.name = name
		self.price = price
	}
}
