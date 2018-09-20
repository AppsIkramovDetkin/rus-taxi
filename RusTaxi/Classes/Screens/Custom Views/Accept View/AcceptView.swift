//
//  AcceptView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 19.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AcceptView: UIView {
	@IBOutlet weak var driverImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var carLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var refuseView: UIView!
	@IBOutlet weak var refuseButton: UIButton!
	@IBOutlet weak var starImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeImageView()
		customizeButton()
		customizeRefuseView()
		hideStarImage()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		driverImageView.layer.cornerRadius = driverImageView.frame.height / 2
		refuseView.layer.cornerRadius = refuseView.frame.height / 2
	}
	
	func showAcceptView() {
		
	}
	
	private func customizeImageView() {
		driverImageView.layer.masksToBounds = false
		driverImageView.clipsToBounds = true
	}
	
	private func hideStarImage() {
		starImageView.isHidden = true
	}
	
	private func customizeRefuseView() {
		refuseView.backgroundColor = TaxiColor.clear
		refuseView.layer.borderWidth = 2
		refuseView.layer.borderColor = TaxiColor.orange.cgColor
	}
	
	private func customizeButton() {
		acceptButton.layer.cornerRadius = 5
	}
}
