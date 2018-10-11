//
//  HeaderCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 02.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var downView: UIView!
	@IBOutlet weak var myPositionView: UIView!
	@IBOutlet weak var myPositionButton: UIButton!
	@IBOutlet weak var indicator: EndlessIndicator!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		indicator.isHidden = true
		customizeMyPositionButtonView()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		myPositionView.layer.cornerRadius = myPositionView.frame.height / 2
	}
	
	private func customizeMyPositionButtonView() {
		myPositionView.clipsToBounds = true
	}
	
	func startLoading() {
		label.isHidden = true
		indicator.isHidden = false
		indicator.startProgressing()
	}
	
	func stopLoading() {
		label.isHidden = false
		indicator.isHidden = true
		indicator.stopProgressing()
	}
}
