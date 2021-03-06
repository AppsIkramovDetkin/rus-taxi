//
//  SearchCarDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SearchCarDataSource: NSObject, MainDataSource {
	private var models: [Address] = []
	var scrollViewScrolled: ScrollViewClosure?
	var scrollViewDragged: ScrollViewClosure?
	var orderTimeClicked: VoidClosure?
	var payTypeClicked: VoidClosure?
	var wishesClicked: VoidClosure?
	var subviewsLayouted: VoidClosure?
	var viewController: MainController?
	var pushClicked: ItemClosure<Int>?
	
	func update(with models: [Any]) {
		if let addressModels = models as? [Address] {
			self.models = addressModels
		}
	}
	
	required init(models: [Address]) {
		self.models = models
		super.init()
		
		OrderManager.shared.priceClosure = { entity in
			guard let lastResponse = OrderManager.shared.lastPriceResponse else {
				return
			}
			let step = lastResponse.step_auction ?? 0
			let money = lastResponse.money_taxo ?? 0
			self.money = money
			self.step = step
			self.newMoney = money
			self.viewController?.tableView.reloadData()
		}
	}
	var newMoney: Double = 0
	var step: Double = 0
	var money: Double = 0
	
	@objc private func orderTimeAction() {
		orderTimeClicked?()
	}
	
	@objc private func wishesAction() {
		wishesClicked?()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scrollViewScrolled?(scrollView)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row > 0 && indexPath.row <= models.count {
			pushClicked?(indexPath.row - 1)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.label.text = nil
			cell.myPositionButton.isHidden = true
			cell.myPositionView.isHidden = true
			return cell
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			let model = models[indexPath.row - 1]
			cell.configure(by: model)
			cell.addressTextField.isEnabled = false
			cell.actionButton.isHidden = true
			cell.topLineView.isHidden = model.position == .top
			cell.botLineView.isHidden = model.pointName == models.last!.pointName
			return cell
		} else if indexPath.row == models.count + 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "propertiesCell", for: indexPath) as! PropertiesCell
			cell.separatorInset = .init(top: 0, left: 41, bottom: 0, right: 16)
			let bookingTime = NewOrderDataProvider.shared.request.booking_time
			let secondPart = bookingTime?.split(separator: "T")[1] ?? ""
			
			let dateFormatter = DateFormatter.init()
			dateFormatter.dateFormat = "HH:mm:ss"
			if let date = dateFormatter.date(from: String(secondPart)) {
				cell.deliveryCarButton.setTitle(date.convertFormateToNormDateString(format: "HH:mm"), for: .normal)
			} else {
				cell.deliveryCarButton.setTitle(Localize("now"), for: .normal)
			}
			cell.orderTimeClicked = orderTimeClicked
			cell.deliveryCarButton.addTarget(self, action: #selector(orderTimeAction), for: .touchUpInside)
			cell.wishesButton.setTitle("(\(NewOrderDataProvider.shared.request.requirements?.count ?? 0))", for: .normal)
			cell.wishesButton.addTarget(self, action: #selector(wishesAction), for: .touchUpInside)
			return cell
		} else if indexPath.row == models.count + 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "pricesCell", for: indexPath) as! PricesCell
			func changePrice(plus: Bool) {
				if plus {
					self.newMoney += step
				} else {
					self.newMoney -= step
				}
				
				tableView.reloadData()
			}
			let response = OrderManager.shared.lastPriceResponse
			cell.priceLabel.text = "+\(response?.money_taxo ?? 0)"
			cell.additionalPrice.text = "\(newMoney ?? -1)"
			cell.minPriceClicked = {
				changePrice(plus: false)
			}
			cell.plusPriceClicked = {
				changePrice(plus: true)
			}
			return cell
		} else if indexPath.row == models.count + 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "callTaxiCell", for: indexPath) as! CallTaxiCell
			cell.callButton.setTitle(Localize("upPrice"), for: .normal)
			cell.callButtonClicked = {
				let localId = StatusSaver.shared.retrieve()?.local_id ?? ""
				OrderManager.shared.setPrice(for: localId, money: self.newMoney)
			}
			cell.callButton.titleLabel?.font = TaxiFont.helveticaMedium
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count + 6
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		scrollViewDragged?(scrollView)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		subviewsLayouted?()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 || indexPath.row == models.count + 3 {
			return 45
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			return 50
		} else if indexPath.row == models.count + 1 {
			return 41
		} else if indexPath.row == models.count + 2 {
			return 73
		}
		return 0
	}
}
