//
//  TaxiTypeModel.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 15.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class TaxiTypeModel {
	var typeName: String
	var price: Double
	var isSelected: Bool = false
	
	init(typeName: String, price: Double) {
		self.typeName = typeName
		self.price = price
	}
}
