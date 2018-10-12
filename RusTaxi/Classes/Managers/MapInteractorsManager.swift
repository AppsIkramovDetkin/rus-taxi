//
//  MapInteractorsManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import GoogleMaps

final class MapInteractorsManager {
	private let mapView: GMSMapView
	private(set) lazy var nearCarInteractor = MapInteractor<NearCarMarker>(mapView: mapView)
	private(set) lazy var addressCarInteractor = MapInteractor<AddressMarker>(mapView: mapView)
	
	init(_ mapView: GMSMapView) {
		self.mapView = mapView
	}
	
	func show(_ markers: [GMSMarker]) {
		if let array = markers as? [NearCarMarker] {
			nearCarInteractor.show(markers: array)
		} else if let array = markers as? [AddressMarker] {
			addressCarInteractor.show(markers: array)
			mapView.fit(markers: array)
		}
	}
	
	func clearMarkers(of type: MapInteractorType) {
		switch type {
			case .nearCar: nearCarInteractor.deleteMarkers()
			case .address: addressCarInteractor.deleteMarkers()
		}
	}
}

enum MapInteractorType {
	case nearCar
	case address
}
