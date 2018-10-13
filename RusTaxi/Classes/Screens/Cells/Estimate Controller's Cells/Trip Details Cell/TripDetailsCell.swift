//
//  TripDetailsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import GoogleMaps

class TripDetailsCell: UITableViewCell {
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var carLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var tripPriceLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeImage()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
	}
	
	private func customizeImage() {
		avatarImageView.layer.masksToBounds = false
		avatarImageView.clipsToBounds = true
	}
}
