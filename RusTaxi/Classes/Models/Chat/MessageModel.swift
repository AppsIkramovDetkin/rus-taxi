//
//  ChatModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class MessageModel: Decodable {
	var id: String?
	var who: Bool?
	var msg: String?
}
