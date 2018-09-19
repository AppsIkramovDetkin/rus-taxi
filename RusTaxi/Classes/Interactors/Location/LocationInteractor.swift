//
//  LocationInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 19/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

typealias AddressModelClosure = ItemClosure<AddressModel>?
class LocationInteractor {
	var location: CLLocationCoordinate2D
	
	required init(location: CLLocationCoordinate2D) {
		self.location = location
	}
	
	func response(closure: AddressModelClosure?) {
		
	}
}
