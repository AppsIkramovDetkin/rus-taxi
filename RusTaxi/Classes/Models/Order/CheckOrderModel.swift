//
//  CheckOrderModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class CheckOrderModel: Decodable {
	var result: String?
	var err_txt: String?
	var uuid: String?
	var puuid: String?
	var dci: String?
	var route: String?
	var numzakaz: String?
	var pname: String?
	var url_photo: String?
	var tmodel: String?
	var tmarka: String?
	var car_color: String?
	var gos_num: String?
	var typepay: String?
	var offer_drivers: [OfferDriverModel]?
	var cause_order: [CauseOrderModel]?
	var statuscomment: String?
	var extra: String?
	var lat: Double?
	var lon: Double?
	var direction: Double?
	var money_order: Double?
	var distance_order: Double?
	var phone_dial: String?
	var is_dial_order: Int?
	var dist: Double?
	var time: Double?
	var beforecloseorder: Int?
	var beforemoney: Double?
	var urlwebmoney: String?
	var status: String?
}
