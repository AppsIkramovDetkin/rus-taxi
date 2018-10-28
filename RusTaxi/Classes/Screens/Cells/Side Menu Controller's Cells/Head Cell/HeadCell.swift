//
//  HeadCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class HeadCell: UITableViewCell {
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var bonusesLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeAvatarImage()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
	}
	
	private func customizeAvatarImage() {
		avatarImageView.layer.masksToBounds = false
		avatarImageView.clipsToBounds = true
	}
}
