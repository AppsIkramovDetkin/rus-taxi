//
//  FooterButtonView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class FooterButtonView: UITableViewHeaderFooterView, UITextViewDelegate {
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customTextView()
	}
	
	private func customTextView() {
		let linkAttributes = [
			NSAttributedStringKey.link: URL(string: "https://google.com")!,
			NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 11) ?? "Error",
			NSAttributedStringKey.foregroundColor: TaxiColor.turquoise,
			NSAttributedStringKey.underlineColor: TaxiColor.turquoise
			] as [NSAttributedStringKey : Any]
		
		let attributedString = NSMutableAttributedString(string: Localize("footerTextView"))
		
		attributedString.setAttributes(linkAttributes, range: NSMakeRange(68, 48))
		self.textView.delegate = self
		self.textView.attributedText = attributedString
		self.textView.isUserInteractionEnabled = true
		self.textView.isEditable = false
	}
	
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		return true
	}
	
	func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		return true
	}
}
