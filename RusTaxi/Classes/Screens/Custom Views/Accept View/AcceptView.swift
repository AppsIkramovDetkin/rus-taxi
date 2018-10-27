//
//  AcceptView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 19.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AcceptView: UIView, NibLoadable {
	@IBOutlet weak var driverImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var carLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var refuseView: UIView!
	@IBOutlet weak var refuseButton: UIButton!
	@IBOutlet weak var starImageView: UIImageView!
	
	private(set) var model: OfferDriverModel?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeImageView()
		customizeButton()
		customizeRefuseView()
		hideStarImage()
		acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
		refuseButton.addTarget(self, action: #selector(refuseButtonAction), for: .touchUpInside)
	}
	
	var acceptButtonClicked: VoidClosure?
	var declineButtonClicked: VoidClosure?
	
	func configure(by model: OfferDriverModel?) {
		self.model = model
		if let url = URL(string: model?.url_photo ?? "") {
			driverImageView.af_setImage(withURL: url)
		}
		
		nameLabel.text = model?.fio
		carLabel.text = model?.car_info
		acceptButton.setTitle("\(model?.offer_money ?? "") ₽ ПРИНЯТЬ", for: .normal)
	}
	
	@objc private func acceptButtonAction() {
		acceptButtonClicked?()
	}
	
	@objc private func refuseButtonAction() {
		declineButtonClicked?()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		driverImageView.layer.cornerRadius = driverImageView.frame.height / 2
		refuseView.layer.cornerRadius = refuseView.frame.height / 2
	}
	
	private func customizeImageView() {
		driverImageView.layer.masksToBounds = false
		driverImageView.clipsToBounds = true
	}
	
	private func hideStarImage() {
		starImageView.isHidden = true
	}
	
	private func customizeRefuseView() {
		refuseView.backgroundColor = TaxiColor.clear
		refuseView.layer.borderWidth = 2
		refuseView.layer.borderColor = TaxiColor.orange.cgColor
	}
	
	private func customizeButton() {
		acceptButton.layer.cornerRadius = 5
	}
}
