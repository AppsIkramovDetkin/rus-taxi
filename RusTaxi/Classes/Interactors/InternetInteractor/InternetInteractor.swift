//
//  InternetInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class InternetInteractor {
	static let shared = InternetInteractor()
	private init() {}
	
	var requestStarted: VoidClosure?
	var requestEnded: VoidClosure?
}
