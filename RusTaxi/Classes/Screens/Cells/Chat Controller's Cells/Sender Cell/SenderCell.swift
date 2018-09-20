//
//  SenderCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 15.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
	@IBOutlet weak var messageView: UIView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeView()
	}
	
	private func customizeView() {
		messageView.layer.cornerRadius = 13
		messageView.clipsToBounds = true
	}
}
