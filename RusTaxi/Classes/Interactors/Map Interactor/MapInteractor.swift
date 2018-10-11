//
//  MapInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import GoogleMaps

protocol MapInteractable {
	associatedtype MarkerType
	
	func show(markers: [MarkerType])
}

class MapInteractor<T: GMSMarker>: MapInteractable {
	typealias MarkerType = T
	private let mapView: GMSMapView
	private(set) var markers: [T] = []
	
	init(mapView: GMSMapView) {
		self.mapView = mapView
	}
	
	func show(markers: [T]) {
		deleteMarkers()
		self.markers = markers
		showMarkers()
	}
	
	func select(address: Address) {
		
		for marker in markers where marker.position.latitude == CLLocationDegrees(address.response?.lat ?? "") && marker.position.longitude == CLLocationDegrees(address.response?.lon ?? "") {
			self.mapView.animate(toLocation: marker.position)
			self.mapView.animate(toZoom: 16.0)
		}
	}
	
	private func showMarkers() {
		markers.forEach {
			$0.map = mapView
		}
	}
	
	func deleteMarkers() {
		markers.forEach {
			$0.map = nil
		}
		markers.removeAll()
	}
}

