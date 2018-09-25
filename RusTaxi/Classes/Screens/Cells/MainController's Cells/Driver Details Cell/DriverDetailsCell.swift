//
//  DriverDetailsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 16.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import AlamofireImage

class DriverDetailsCell: UITableViewCell {
	@IBOutlet weak var driverImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var carLabel: UILabel!
	@IBOutlet weak var carColorLabel: UILabel!
	@IBOutlet weak var callButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeImage()
		customizeButton()
	}
	
	func configure(by response: CheckOrderModel) {
		if let url = URL(string: response.url_photo ?? "") {
			driverImageView.af_setImage(withURL: url)
		}
		
		nameLabel.text = response.pname
		carLabel.text = [response.tmarka, response.tmodel, response.gos_num].compactMap { $0 }.joined()
		carColorLabel.text = response.car_color
	}
	
	private func customizeButton() {
		callButton.layer.cornerRadius = 0.5 * callButton.bounds.size.width
		callButton.clipsToBounds = true
	}
	
	private func customizeImage() {
		driverImageView.layer.masksToBounds = false
		driverImageView.layer.cornerRadius = driverImageView.frame.height / 2
		driverImageView.clipsToBounds = true
	}
}
