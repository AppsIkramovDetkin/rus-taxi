//
//  Slide.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 24.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class Slide: UIView {
	@IBOutlet weak var slideImage: UIImageView!
	@IBOutlet weak var slideTextView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		contentModeSlide()
	}
	
	private func contentModeSlide() {
		slideImage.contentMode = .scaleAspectFit
	}
}
