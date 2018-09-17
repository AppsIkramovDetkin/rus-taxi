//
//  OfferDriverModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class OfferDriverModel: Decodable {
	var pers_uuid: String?
	var rating: String?
	var url_photo: String?
	var is_block: Int?
	var fio: String?
	var car_info: String?
	var distance: String?
	var offer_money: String?
}
