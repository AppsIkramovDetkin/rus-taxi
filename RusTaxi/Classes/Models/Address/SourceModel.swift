//
//  SourceModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation

class AddressModel: Encodable {
	var home_id: Int?
	var num: Int?
	var country: String?
	var region: String?
	var street: String?
	var home: String?
	var porch: String?
	var comment: String?
	var lat: CLLocationDegrees?
	var lon: CLLocationDegrees?
}
