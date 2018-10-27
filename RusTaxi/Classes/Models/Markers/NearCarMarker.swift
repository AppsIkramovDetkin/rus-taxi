//
//  NearCarMarker.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import GoogleMaps

class NearCarMarker: GMSMarker {
	let uuid: String?
	
	init(nearCarResponse: NearCarResponse) {
		self.uuid = nearCarResponse.uuid
		super.init()
		if let unboxDirection = nearCarResponse.direction {
			self.rotation = CLLocationDegrees(unboxDirection)
		}
//		nearCarResponse.direction
		self.position = CLLocationCoordinate2D(latitude: nearCarResponse.lat ?? 0, longitude: nearCarResponse.lon ?? 0)
		let newSize = CGSize(width: 20, height: 33)
		self.icon = UIImage(named: "ic_standard_car_select")!.af_imageScaled(to: newSize)
	}
}
