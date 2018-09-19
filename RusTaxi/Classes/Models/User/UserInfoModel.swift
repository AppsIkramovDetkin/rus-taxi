//
//  UserInfoModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class UserInfoModelResponse: Decodable {
	var Ver: String?
	var Command: String?
	var result: String?
	var err_txt: String?
	var order_uuid: String?
	var bonus: String?
	var url_client: String?
	var birthday: String?
	var f: String?
	var i: String?
	var o: String?
	var main_menu_fio: String?
	var main_menu_bonus: String?
	var email: String?
	var allow_email_notif: String?
	var comment: String?
	var share_sub: String?
	var share_body: String?
	var phone: String?
	var phone_prefix: String?
	var org_name: String?
	var uuid_org: String?
	var tariffs: [TarifResponse]?
}
