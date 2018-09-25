//
//  HeaderCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 02.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
	@IBOutlet weak var downView: UIView!
	@IBOutlet weak var myPositionView: UIView!
	@IBOutlet weak var myPositionButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeMyPositionButtonView()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		myPositionView.layer.cornerRadius = myPositionView.frame.height / 2
	}
	
	private func customizeMyPositionButtonView() {
		myPositionView.clipsToBounds = true
	}
}
