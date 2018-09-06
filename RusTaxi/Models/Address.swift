//
//  Address.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 05.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class Address {
	var pointName: String
	var country: String = ""
	var address: String = ""
	
	init(pointName: String) {
		self.pointName = pointName
	}
}
