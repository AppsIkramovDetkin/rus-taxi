//
//  StatusModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 25/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class StatusModel: Codable {
	var local_id: String?
	var status: String?
	var addressModels: [Address] = []
}
