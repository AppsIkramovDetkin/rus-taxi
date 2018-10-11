//
//  AddressMarker.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import GoogleMaps

class AddressMarker: GMSMarker {
	let pointName: String
	
	init(address: Address) {
		self.pointName = address.pointName
		let lon = CLLocationDegrees(address.response?.lon ?? "") ?? 0
		let lat = CLLocationDegrees(address.response?.lat ?? "") ?? 0
		super.init()
		self.position = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
		let iconView = CenterView.loadFromNib()
		iconView.set(address: address)
		iconView.frame.size = CGSize(width: 40, height: 50.5)
		self.iconView = iconView
	}
}
