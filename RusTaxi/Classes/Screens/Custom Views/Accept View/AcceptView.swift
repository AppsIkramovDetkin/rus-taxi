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
		customizeAcceptView()
		hideStarImage()
	}
	
	private func customizeAcceptView() {
	}
	
	private func customizeImageView() {
		driverImageView.layer.masksToBounds = false
		driverImageView.layer.cornerRadius = driverImageView.frame.height/2
		driverImageView.clipsToBounds = true
	}
	
	private func hideStarImage() {
		starImageView.isHidden = true
	}
	
	private func customizeRefuseView() {
		refuseView.backgroundColor = TaxiColor.clear
		refuseView.layer.borderWidth = 2
		refuseView.layer.borderColor = TaxiColor.orange.cgColor
		refuseView.layer.cornerRadius = refuseView.frame.height/2
	}
	
	private func customizeButton() {
		acceptButton.layer.cornerRadius = 5
	}
}

extension UIView {
	
	func dropShadow(scale: Bool = true) {
		layer.masksToBounds = false
		layer.shadowColor = TaxiColor.black.cgColor
		layer.shadowOpacity = 6
		layer.shadowOffset = CGSize(width: -1, height: 1)
		layer.shadowRadius = 3
		
		layer.shadowPath = UIBezierPath(rect: bounds).cgPath
		layer.shouldRasterize = true
		layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
}
