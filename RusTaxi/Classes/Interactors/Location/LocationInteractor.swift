//
//  LocationInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 19/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class LocationInteractor {
	private let throttleTime: Time = Time(0.75)
	private var coordinate: CLLocationCoordinate2D
	
	required init(_ location: CLLocationCoordinate2D) {
		self.coordinate = location
	}
	
	func response(closure: @escaping OptionalItemClosure<NearStreetResponseModel>) {
		Throttler.shared.throttle(time: throttleTime) {
			AddressManager.shared.findNearStreet(location: self.coordinate, closure: { (model) in
				closure(model)
			})
		}
	}
}


