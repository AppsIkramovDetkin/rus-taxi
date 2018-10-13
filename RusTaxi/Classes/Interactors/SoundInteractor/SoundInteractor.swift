//
//  SoundInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 11/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import AVFoundation

class SoundInteractor {
	private init() {}
	class func playDefault() {
		AudioServicesPlayAlertSound(SystemSoundID(1322))
	}
}
