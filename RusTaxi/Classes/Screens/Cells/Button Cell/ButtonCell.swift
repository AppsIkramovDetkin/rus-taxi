//
//  ButtonCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
	@IBOutlet weak var sendButton: UIButton!
	
	private var seconds = 20
	private var timer = Timer()
	private var isTimerRunning = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		actionSendButton()
	}
	
	@objc private func sendButtonClicked() {
		timer.invalidate()// reload counter
		seconds = 20 //reload seconds
		isTimerRunning = false
		if isTimerRunning == false {
			runTimer()
			self.sendButton.isEnabled = false
			self.sendButton.backgroundColor = TaxiColor.clear
		}
	}
	
	private func actionSendButton() {
		sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
	}
	
	private func runTimer() {
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ButtonCell.updateTimer)), userInfo: nil, repeats: true)
		isTimerRunning = true
	}
	
	@objc private func updateTimer() {
		if seconds < 1 {
			timer.invalidate()
		} else {
			seconds -= 1
			UIView.performWithoutAnimation {
				sendButton.setTitle(Localize("againCode") + String(seconds) + Localize("sec"), for: .normal)
				sendButton.layoutIfNeeded()
			}
		}
		
		if seconds == 0 {
			sendButton.backgroundColor = TaxiColor.darkOrange
			sendButton.setTitle(Localize("takeCode"), for: .normal)
			sendButton.setTitleColor(TaxiColor.black, for: .normal)
			sendButton.isEnabled = true
		}
	}
	
	private func timeString(time:TimeInterval) -> String {
		let seconds = Int(time) % 60
		return String(format:"%02i:%02i:%02i", seconds)
	}
}
