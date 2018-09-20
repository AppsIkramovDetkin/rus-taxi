//
//  LocationInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 19/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

protocol LocationInteractorDelegate {
	func didUpdateLocations(locations: [CLLocation])
}

class LocationInteractor: NSObject, CLLocationManagerDelegate {
	private let throttleTime: Time = Time(0.75)
	private let locationManager: CLLocationManager = CLLocationManager()
	private(set) var myLocation: CLLocationCoordinate2D?
	private override init() {
		super.init()
		locationManager.delegate = self
	}
	
	private var observers: [LocationInteractorDelegate] = []
	static let shared = LocationInteractor()
	
	func response(location: CLLocationCoordinate2D, closure: @escaping OptionalItemClosure<NearStreetResponseModel>) {
		Throttler.shared.throttle(time: throttleTime) {
			AddressManager.shared.findNearStreet(location: location, closure: { (model) in
				closure(model)
			})
		}
	}
	
	func startUpdateLocation() {
		locationManager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		myLocation = locations.first?.coordinate
		observers.forEach { $0.didUpdateLocations(locations: locations) }
	}
	
	func addObserver(delegate: LocationInteractorDelegate) {
		observers.append(delegate)
	}
}


