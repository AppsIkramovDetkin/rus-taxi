//
//  StartDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 15.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

@objc protocol MainDataSource: class, UITableViewDelegate, UITableViewDataSource {
	var scrollViewScrolled: ScrollViewClosure? { get set}
	func update(with models: [Any])
}

class MainControllerDataSource: NSObject, MainDataSource {
	typealias ModelType = Address
	private var models: [Address]
	
	// callbacks
	var currentLocationClicked: VoidClosure?
	var actionAddClicked: VoidClosure?
	var deleteCellClicked: ViewClosure?
	var payTypeClicked: VoidClosure?
	var wishesClicked: VoidClosure?
	var subviewsLayouted: VoidClosure?
	var pushClicked: ItemClosure<Int>?
	var scrollViewScrolled: ScrollViewClosure?
	var scrollViewDragged: ScrollViewClosure?
	//
	
	required init(models: [Address]) {
		self.models = models
		super.init()
	}
	
	@objc private func currentLocationAction() {
		currentLocationClicked?()
	}

	
	@objc private func deleteCellAction(sender: UIButton) {
		deleteCellClicked?(sender)
	}
	
	@objc private func actionButtonAdd() {
		actionAddClicked?()
	}
	
	@objc private func payTypeAction() {
		payTypeClicked?()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.scrollViewScrolled?(scrollView)
	}
	
	@objc private func wishesAction() {
		wishesClicked?()
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		subviewsLayouted?()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.myPositionButton.addTarget(self, action: #selector(currentLocationAction), for: .touchUpInside)
			return cell
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			let model = models[indexPath.row - 1]
			cell.configure(by: model)
			cell.addressTextField.isEnabled = false
			cell.topLineView.isHidden = model.position == .top
			cell.botLineView.isHidden = model.pointName == models.last!.pointName
			switch model.state {
			case .default:
				cell.actionButton.isHidden = true
			case .add:
				cell.actionButton.isHidden = false
				cell.actionButton.setImage(icons[0], for: .normal)
				cell.actionButton.removeTarget(self, action: nil, for: .allEvents)
				cell.actionButton.addTarget(self, action: #selector(actionButtonAdd), for: .touchUpInside)
			default:
				cell.actionButton.isHidden = false
				cell.actionButton.removeTarget(self, action: nil, for: .allEvents)
				cell.actionButton.setImage(icons[1], for: .normal)
				cell.actionButton.addTarget(self, action: #selector(deleteCellAction), for: .touchUpInside)
			}
			return cell
		} else if indexPath.row == models.count + 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
			cell.payTypeButton.addTarget(self, action: #selector(payTypeAction), for: .touchUpInside)
			cell.wishesButton.addTarget(self, action: #selector(wishesAction), for: .touchUpInside)
			cell.priceTextField.underline()
			return cell
		} else if indexPath.row == models.count + 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "chooseTaxiCell", for: indexPath) as! ChooseTaxiCell
			return cell
		} else if indexPath.row == models.count + 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "callTaxiCell", for: indexPath) as! CallTaxiCell
			return cell
		}
		return UITableViewCell()
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		scrollViewDragged?(scrollView)
	}
	
	func update(with models: [Any]) {
		if let addressModels = models as? [Address] {
			self.models = addressModels
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row > 0 && indexPath.row <= models.count {
			pushClicked?(indexPath.row - 1)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 33
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			return 35
		} else if indexPath.row == models.count + 1 {
			return 41
		} else if indexPath.row == models.count + 2 {
			return 66
		} else {
			return 30
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count + 4
	}
}
