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
	static let sec = 20
	static var seconds = sec
	
	static var isTimerRunning: Bool {
		return seconds != sec
	}
	var buttonClicked: (() -> Void)?
	override func awakeFromNib() {
		super.awakeFromNib()
		
		actionSendButton()
		
		func f() {
			delay(delay: 0.2) {
				self.sendButton.isEnabled = !ViewController.isInRequest && !ButtonCell.isTimerRunning
				f()
			}
		}
	}
	
	@objc private func sendButtonClicked() {
		self.sendButton.isEnabled = false
		self.sendButton.backgroundColor = TaxiColor.clear
		self.sendButton.setTitle(Localize("againCode") + String(ButtonCell.seconds) + Localize("sec"), for: .normal)
		
		guard ButtonCell.isTimerRunning == false else {
			return
		}

		func da() {
			delay(delay: 1) {
				ButtonCell.seconds -= 1
				UIView.performWithoutAnimation {
					self.sendButton.setTitle(Localize("againCode") + String(ButtonCell.seconds) + Localize("sec"), for: .normal)
					self.sendButton.layoutIfNeeded()
				}
				if ButtonCell.seconds == 0 {
					self.sendButton.backgroundColor = TaxiColor.darkOrange
					self.sendButton.setTitle(Localize("takeCode"), for: .normal)
					self.sendButton.setTitleColor(TaxiColor.black, for: .normal)
					self.sendButton.isEnabled = true
					ButtonCell.seconds = ButtonCell.sec
				} else {
					da()
				}
			}
		}
		da()
		buttonClicked?()
	}
	
	private func actionSendButton() {
		sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
	}
	private func timeString(time:TimeInterval) -> String {
		let seconds = Int(time) % 60
		return String(format:"%02i:%02i:%02i", seconds)
	}
}
