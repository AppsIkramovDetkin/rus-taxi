//
//  OnDriveDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 16.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class OnDriveDataSource: NSObject, MainDataSource {
	private var models: [Address] = []
	
	func update(with models: [Any]) {
		if let addressModels = models as? [Address] {
			self.models = addressModels
		}
	}
	
	required init(models: [Address]) {
		self.models = models
		super.init()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.myPositionButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "driveCell", for: indexPath) as! DriveDetailsCell
			cell.separatorInset = .init(top: 0, left: 41, bottom: 0, right: 16)
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath) as! DriverDetailsCell
			cell.separatorInset = .init(top: 0, left: 41, bottom: 0, right: 16)
			return cell
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			let model = models[indexPath.row - 1]
			cell.configure(by: model)
			cell.topLineView.isHidden = model.position == .top
			cell.separatorInset = .init(top: 0, left: 41, bottom: 0, right: 16)
			cell.botLineView.isHidden = model.pointName == models.last!.pointName
			return cell
		} else if indexPath.row == models.count + 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
			cell.priceTextField.isHidden = true
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count + 4
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 33
		} else if indexPath.row == 1 {
			return 34
		} else if indexPath.row == 2 {
			return 76
		} else if indexPath.row > 2 && indexPath.row <= models.count {
			return 63
		} else if indexPath.row == models.count + 1 {
			return 41
		}
		return 0
	}
}
