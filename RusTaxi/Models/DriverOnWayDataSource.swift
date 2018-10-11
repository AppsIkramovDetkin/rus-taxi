//
//  DriverOnWayDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class DriverOnWayDataSource: NSObject, MainDataSource {
	private var models: [Address] = []
	var pushClicked: ItemClosure<Int>?
	var viewController: UIViewController?
	var chatClicked: VoidClosure?
	var scrollViewScrolled: ScrollViewClosure?
	func update(with models: [Any]) {
		if let addressModels = models as? [Address] {
			self.models = addressModels
		}
	}
	
	private var response: CheckOrderModel?
	
	required init(models: [Address], response: CheckOrderModel? = nil) {
		self.models = models
		self.response = response
		super.init()
	}
	
	@objc private func chatAction() {
		chatClicked?()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row > 1 && indexPath.row <= models.count + 1 {
			pushClicked?(indexPath.row - 2)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.label.text = nil
			cell.myPositionButton.isHidden = false
			cell.myPositionView.isHidden = false
			cell.myPositionButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
			cell.myPositionView.backgroundColor = TaxiColor.taxiOrange
			cell.myPositionButton.addTarget(self, action: #selector(chatAction), for: .touchUpInside)
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath) as! DriverDetailsCell
			cell.callButtonClicked = {
				let saver = StatusSaver.shared.retrieve()
				let orderId = saver?.local_id ?? ""
				let status = saver?.status ?? ""
				ChatManager.shared.dialDriver(orderId: orderId, order_status: status, with: { (message) in
					self.viewController?.showAlert(title: "Связь с водителем", message: message ?? "")
				})
			}
			if let response = response {
				cell.configure(by: response)
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
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count + 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 45
		} else if indexPath.row == 1 {
			return 76
		} else if indexPath.row > 1 && indexPath.row <= models.count + 1 {
			return 50
		} else if indexPath.row == models.count + 2 {
			return 41
		}
		return 0
	}
}
