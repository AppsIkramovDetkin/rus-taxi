//
//  CancelOrderResponseModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 25/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
//{"result":"done","err_txt":"Заказ отменен","uuid":"12344"}

class CancelOrderResponseModel: Decodable {
	var result: String?
	var err_txt: String?
	var uuid: String?
}
