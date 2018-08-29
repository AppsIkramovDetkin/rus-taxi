//
//  FooterButtonView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class FooterButtonView: UITableViewCell, UITextViewDelegate {
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	
	private let rangeAttributedString = NSRange.init(location: 68, length: 48)
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customTextView()
	}
	
	private func customTextView() {
		let linkAttributes = [
			NSAttributedStringKey.link: URL(string: "https://google.com")!,
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11),
			NSAttributedStringKey.foregroundColor: TaxiColor.turquoise,
			NSAttributedStringKey.underlineColor: TaxiColor.turquoise
			] as [NSAttributedStringKey : Any]
		
		let attributedString = NSMutableAttributedString(string: Localize("footerTextView"))
		
		attributedString.setAttributes(linkAttributes, range: rangeAttributedString)
		self.textView.delegate = self
		self.textView.attributedText = attributedString
		self.textView.isUserInteractionEnabled = true
		self.textView.isEditable = false
	}
	
	@available(iOS 10.0, *)
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		return true
	}
	
	@available(iOS 10.0, *)
	func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		return true
	}
}
