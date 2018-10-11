//
//  MapInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import GoogleMaps

class MapInteractor {
	private let mapView: GMSMapView
	private(set) var markers: [NearCarMarker] = []
	
	init(mapView: GMSMapView) {
		self.mapView = mapView
	}
	
	func show(nearCars: [NearCarResponse]) {
		deleteMarkers()
		let markers = nearCars.map { NearCarMarker(nearCarResponse: $0) }
		self.markers = markers
		showMarkers()
	}
	
	private func showMarkers() {
		markers.forEach {
			$0.map = mapView
		}
	}
	
	private func deleteMarkers() {
		markers.forEach {
			$0.map = nil
		}
		markers.removeAll()
	}
}

class NearCarMarker: GMSMarker {
	let uuid: String?
	
	init(nearCarResponse: NearCarResponse) {
		self.uuid = nearCarResponse.uuid
		super.init()
		self.position = CLLocationCoordinate2D(latitude: nearCarResponse.lat ?? 0, longitude: nearCarResponse.lon ?? 0)
		let newSize = CGSize(width: 20, height: 33)
		self.icon = UIImage(named: "ic_standard_car_select")!.af_imageScaled(to: newSize)
	}
}
