//
//  CarWaitingDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 25.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class CarWaitingDataSource: NSObject, MainDataSource {
	
	private var models: [Address] = []
	var scrollViewScrolled: ScrollViewClosure?
	var scrollViewDragged: ScrollViewClosure?
	var pushClicked: ItemClosure<Int>?
	var subviewsLayouted: VoidClosure?
	var payTypeClicked: VoidClosure?
	var chatClicked: VoidClosure?
	var viewController: UIViewController?
	var response: CheckOrderModel?

	func update(with models: [Any]) {
		if let addressModels = models as? [Address] {
			self.models = addressModels
		}
	}
	
	@objc private func chatAction() {
		chatClicked?()
	}
	
	@objc private func payTypeAction() {
		payTypeClicked?()
	}
	
	required init(models: [Address], response: CheckOrderModel? = nil) {
		self.models = models
		super.init()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row > 1 && indexPath.row <= models.count + 1 {
			self.pushClicked?(indexPath.row - 2)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.label.text = nil
			cell.myPositionButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
			cell.myPositionButton.isHidden = false
			cell.myPositionView.isHidden = false
			cell.myPositionView.backgroundColor = TaxiColor.taxiOrange
			cell.myPositionButton.addTarget(self, action: #selector(chatAction), for: .touchUpInside)
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath) as! DriverDetailsCell
			if let response = response {
				cell.configure(by: response)
			}
			cell.callButtonClicked = {
				let saver = StatusSaver.shared.retrieve()
				let orderId = saver?.local_id ?? ""
				let status = saver?.status ?? ""
				ChatManager.shared.dialDriver(orderId: orderId, order_status: status, with: { (message) in
					self.viewController?.showAlert(title: "Связь с водителем", message: message ?? "")
				})
			}
			return cell
		} else if indexPath.row > 1 && indexPath.row <= models.count + 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			let model = models[indexPath.row - 2]
			cell.actionButton.isHidden = true
			cell.addressTextField.isEnabled = false
			cell.configure(by: model)
			cell.topLineView.isHidden = model.position == .top
			cell.separatorInset = .init(top: 0, left: 41, bottom: 0, right: 16)
			cell.botLineView.isHidden = model.pointName == models.last!.pointName
			return cell
		} else if indexPath.row == models.count + 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "propertiesCell", for: indexPath) as! PropertiesCell
			cell.wishesButton.setTitle("(\(NewOrderDataProvider.shared.request.requirements?.count ?? 0))", for: .normal)
			cell.payButton.addTarget(self, action: #selector(payTypeAction), for: .touchUpInside)
			return cell
		} else if indexPath.row == models.count + 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "callTaxiCell", for: indexPath) as! CallTaxiCell
			cell.callButton.setTitle("Я ВЫХОЖУ", for: .normal)
			cell.callButtonClicked = {
				let saverModel = StatusSaver.shared.retrieve()
				let orderId = saverModel?.local_id ?? ""
				let status = saverModel?.status ?? ""
				cell.callButton.backgroundColor = TaxiColor.lightGray
				OrderManager.shared.confirmExit(local_id: orderId, order_status: status, closure: { (checkResponse) in
					cell.callButton.setTitle("✓", for: .normal)
					delay(delay: 1, closure: {
						cell.callButton.setTitle("Я ВЫХОЖУ", for: .normal)
					})
				})
			}
			cell.callButton.titleLabel?.font = TaxiFont.helveticaMedium
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count + 5
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
		} else if indexPath.row == 1 {
			return 76
		} else if indexPath.row > 1 && indexPath.row <= models.count + 1 {
			return 35
		} else if indexPath.row == models.count + 2 {
			return 41
		}
		return 0
	}
}
