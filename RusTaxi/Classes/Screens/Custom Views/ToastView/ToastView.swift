//
//  ToastView.swift
//  RusTaxi
//
//  Created by Danil Detkin on 20/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ToastView: UIView, NibLoadable {
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var label: UILabel!
	
	var buttonClicked: VoidClosure?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		doneButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
	}
	
	@objc private func buttonAction() {
		buttonClicked?()
	}
	
	func set(text: String) {
		label.text = text
	}
}
