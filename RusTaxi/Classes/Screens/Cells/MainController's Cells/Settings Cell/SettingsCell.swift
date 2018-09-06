//
//  SettingsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 02.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
	@IBOutlet weak var priceTextField: UITextField!
	@IBOutlet weak var economyView: UIView!
	@IBOutlet weak var economyCar: UIImageView!
	@IBOutlet weak var nameEconomyLabel: UILabel!
	@IBOutlet weak var priceEconomyLabel: UILabel!
	@IBOutlet weak var webBusinessView: UIView!
	@IBOutlet weak var webBusinessCar: UIImageView!
	@IBOutlet weak var nameWebBusinessLabel: UILabel!
	@IBOutlet weak var priceWebBusinessLabel: UILabel!
	@IBOutlet weak var comfortView: UIView!
	@IBOutlet weak var comfortCar: UIImageView!
	@IBOutlet weak var nameComfortLabel: UILabel!
	@IBOutlet weak var priceComfortLabel: UILabel!
	@IBOutlet weak var businessView: UIView!
	@IBOutlet weak var businessCar: UIImageView!
	@IBOutlet weak var nameBusinessLabel: UILabel!
	@IBOutlet weak var priceBusinessLabel: UILabel!
	@IBOutlet weak var callTaxiButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeTextField()
		customizeViews()
		addGestures()
	}
	
	private func addGestures() {
		let economyViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(economyViewHandleTapGesture(sender: )))
		let webBusinessViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(webBusinessViewHandleTapGesture(sender: )))
		let comfortViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(comfortViewHandleTapGesture(sender: )))
		let businessViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(businessViewHandleTapGesture(sender: )))
		economyView.isUserInteractionEnabled = true
		webBusinessView.isUserInteractionEnabled = true
		comfortView.isUserInteractionEnabled = true
		businessView.isUserInteractionEnabled = true
		
		economyView.addGestureRecognizer(economyViewGestureRecognizer)
		webBusinessView.addGestureRecognizer(webBusinessViewGestureRecognizer)
		comfortView.addGestureRecognizer(comfortViewGestureRecognizer)
		businessView.addGestureRecognizer(businessViewGestureRecognizer)
	}
	
	@objc fileprivate func economyViewHandleTapGesture(sender: UITapGestureRecognizer) {
		callTaxiButton.setTitle("Заказать эконом", for: .normal)
		economyCar.image = #imageLiteral(resourceName: "ic_standard_car_select")
		webBusinessCar.image = #imageLiteral(resourceName: "ic_standard_car")
		comfortCar.image = #imageLiteral(resourceName: "ic_standard_car")
		businessCar.image = #imageLiteral(resourceName: "ic_standard_car")
		nameEconomyLabel.textColor = TaxiColor.black
		priceEconomyLabel.textColor = TaxiColor.black
		nameWebBusinessLabel.textColor = TaxiColor.lightGray
		priceWebBusinessLabel.textColor = TaxiColor.lightGray
		nameComfortLabel.textColor = TaxiColor.lightGray
		priceComfortLabel.textColor = TaxiColor.lightGray
		nameBusinessLabel.textColor = TaxiColor.lightGray
		priceBusinessLabel.textColor = TaxiColor.lightGray
	}
	
	@objc fileprivate func webBusinessViewHandleTapGesture(sender: UITapGestureRecognizer) {
		callTaxiButton.setTitle("Заказать web-бизнес", for: .normal)
		economyCar.image = #imageLiteral(resourceName: "ic_standard_car")
		webBusinessCar.image = #imageLiteral(resourceName: "ic_standard_car_select")
		comfortCar.image = #imageLiteral(resourceName: "ic_standard_car")
		businessCar.image = #imageLiteral(resourceName: "ic_standard_car")
		nameEconomyLabel.textColor = TaxiColor.lightGray
		priceEconomyLabel.textColor = TaxiColor.lightGray
		nameWebBusinessLabel.textColor = TaxiColor.black
		priceWebBusinessLabel.textColor = TaxiColor.black
		nameComfortLabel.textColor = TaxiColor.lightGray
		priceComfortLabel.textColor = TaxiColor.lightGray
		nameBusinessLabel.textColor = TaxiColor.lightGray
		priceBusinessLabel.textColor = TaxiColor.lightGray
	}
	
	@objc fileprivate func comfortViewHandleTapGesture(sender: UITapGestureRecognizer) {
		callTaxiButton.setTitle("Заказать комфорт", for: .normal)
		economyCar.image = #imageLiteral(resourceName: "ic_standard_car")
		webBusinessCar.image = #imageLiteral(resourceName: "ic_standard_car")
		comfortCar.image = #imageLiteral(resourceName: "ic_standard_car_select")
		businessCar.image = #imageLiteral(resourceName: "ic_standard_car")
		nameEconomyLabel.textColor = TaxiColor.lightGray
		priceEconomyLabel.textColor = TaxiColor.lightGray
		nameWebBusinessLabel.textColor = TaxiColor.lightGray
		priceWebBusinessLabel.textColor = TaxiColor.lightGray
		nameComfortLabel.textColor = TaxiColor.black
		priceComfortLabel.textColor = TaxiColor.black
		nameBusinessLabel.textColor = TaxiColor.lightGray
		priceBusinessLabel.textColor = TaxiColor.lightGray
	}
	
	@objc fileprivate func businessViewHandleTapGesture(sender: UITapGestureRecognizer) {
		callTaxiButton.setTitle("Заказать бизнес", for: .normal)
		economyCar.image = #imageLiteral(resourceName: "ic_standard_car")
		webBusinessCar.image = #imageLiteral(resourceName: "ic_standard_car")
		comfortCar.image = #imageLiteral(resourceName: "ic_standard_car")
		businessCar.image = #imageLiteral(resourceName: "ic_standard_car_select")
		nameEconomyLabel.textColor = TaxiColor.lightGray
		priceEconomyLabel.textColor = TaxiColor.lightGray
		nameWebBusinessLabel.textColor = TaxiColor.lightGray
		priceWebBusinessLabel.textColor = TaxiColor.lightGray
		nameComfortLabel.textColor = TaxiColor.lightGray
		priceComfortLabel.textColor = TaxiColor.lightGray
		nameBusinessLabel.textColor = TaxiColor.black
		priceBusinessLabel.textColor = TaxiColor.black
	}
	
	private func customizeViews() {
		economyView.layer.cornerRadius = 2
		webBusinessView.layer.cornerRadius = 2
		comfortView.layer.cornerRadius = 2
		businessView.layer.cornerRadius = 2
	}
	
	private func customizeTextField() {
		priceTextField.underline()
	}
}
