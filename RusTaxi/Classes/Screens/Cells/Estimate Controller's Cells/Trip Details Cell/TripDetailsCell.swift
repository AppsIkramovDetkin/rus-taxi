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
	
	func configure(by response: CheckOrderModel) {
		if let avatarURL = URL(string: response.url_photo ?? "") {
			avatarImageView.af_setImage(withURL: avatarURL)
		}
		
		let leftText = [response.tmarka, response.tmodel].compactMap{$0}.joined(separator: "\n")
		carLabel.text = leftText
		
		let rightText = "ИТОГО\n\(response.money_order ?? 0) ₽"
		tripPriceLabel.text = rightText
		
		nameLabel.text = response.pname

		let coordinate = CLLocationCoordinate2D(latitude: response.lat ?? 0, longitude: response.lon ?? 0)
		mapView.animate(toLocation: coordinate)
		mapView.animate(toZoom: 16.0)
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
