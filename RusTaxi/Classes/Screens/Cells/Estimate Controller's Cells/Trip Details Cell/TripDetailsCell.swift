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
	@IBOutlet weak var mapImageView: UIImageView!
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
		let size = ((mapImageView.frame.height * 640) / mapImageView.frame.width)
		let route = (response.route ?? "").replacingOccurrences(of: " ", with: ",")
		let urlString = "https://maps.googleapis.com/maps/api/staticmap?size=640x\(Int(size))&path=color:0x0f2DBAE4\(route)&key=AIzaSyB9tASbaMe10jF08aKZAngZ5q9DB2-Zy0A"
		
		if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
			mapImageView.af_setImage(withURL: url)
		}
		let leftText = [response.tmarka, response.tmodel].compactMap{$0}.joined(separator: "\n")
		carLabel.text = leftText
		
		let rightText = "ИТОГО\n\(response.money_order ?? 0) ₽"
		tripPriceLabel.text = rightText
		
		nameLabel.text = response.pname

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
