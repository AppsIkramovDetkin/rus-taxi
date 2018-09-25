//
//  ReceiverCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 15.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
	@IBOutlet weak var messageView: UIView!
	@IBOutlet weak var messageTextView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeView()
	}
	
	func configure(by model: MessageModel) {
		messageTextView.attributedText = model.msg?.htmlToAttributedString
	}
	
	private func customizeView() {
		messageView.layer.cornerRadius = 4
		messageView.clipsToBounds = true
	}
}

extension String {
	var htmlToAttributedString: NSAttributedString? {
		guard let data = data(using: .utf8) else { return NSAttributedString() }
		do {
			let attr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
			let mut = NSMutableAttributedString(attributedString: attr)
			mut.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: NSRange.init(location: 0, length: attr.length))
			return mut
		} catch {
			return NSAttributedString()
		}
	}
	var htmlToString: String {
		return htmlToAttributedString?.string ?? ""
	}
}
