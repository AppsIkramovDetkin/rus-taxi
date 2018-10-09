//
//  CenterView.swift
//  RusTaxi
//
//  Created by Danil Detkin on 28/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class CenterView: UIView, NibLoadable {
	@IBOutlet weak var bottomStickView: UIView!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var label: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = .clear
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		mainView.layer.cornerRadius = mainView.frame.height / 2
		mainView.borderColor = UIColor.black
		mainView.layer.borderWidth = 2
	}
	
	func clear() {
		set(time: nil)
	}
	
	func set(time: Time?) {
		label.numberOfLines = 2
		var string = ""
		if let unboxTime = time {
			let minutes = Int(unboxTime.seconds / 60)
			string = "\(minutes)\n"
		} else {
			string = "...\n"
		}
		
		let mutableString = NSMutableAttributedString()
		let topAttributed = NSAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0), NSAttributedStringKey.foregroundColor: UIColor.black])
		mutableString.append(topAttributed)
		let bottomAttributed = NSAttributedString(string: "мин.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 7.0), NSAttributedStringKey.foregroundColor: UIColor.black])
		mutableString.append(bottomAttributed)
		label.attributedText = mutableString
	}
}
