//
//  AvatarCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AvatarCell: UITableViewCell {
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var photoView: UIView!
	@IBOutlet weak var photoButton: UIButton!
	@IBOutlet weak var pictureView: UIView!
	@IBOutlet weak var pictureButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeImage()
		customizeViews()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
		photoView.layer.cornerRadius = photoView.frame.height / 2
		pictureView.layer.cornerRadius = pictureView.frame.height / 2
	}
	
	private func customizeImage() {
		avatarImageView.layer.masksToBounds = false
		avatarImageView.clipsToBounds = true
	}
	
	private func customizeViews() {
		photoView.layer.borderWidth = 1
		photoView.layer.borderColor = TaxiColor.orange.cgColor
		pictureView.layer.borderWidth = 1
		pictureView.layer.borderColor = TaxiColor.orange.cgColor
	}
}
