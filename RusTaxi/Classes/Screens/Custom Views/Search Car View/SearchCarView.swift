//
//  SearchCarView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 24.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SearchCarView: UIView, NibLoadable {
	@IBOutlet weak var label: UILabel!
	
	func set(text: String?) {
		label.attributedText = text?.htmlToAttributedString
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
	}
}
