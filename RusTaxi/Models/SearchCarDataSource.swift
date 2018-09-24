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
	var subviewsLayouted: VoidClosure?

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
			cell.myPositionButton.isHidden = true
			return cell
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			let model = models[indexPath.row - 1]
			cell.configure(by: model)
			cell.actionButton.isHidden = true
			cell.topLineView.isHidden = model.position == .top
			cell.botLineView.isHidden = model.pointName == models.last!.pointName
			return cell
		} else if indexPath.row == models.count + 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "propertiesCell", for: indexPath) as! PropertiesCell
			cell.separatorInset = .init(top: 0, left: 41, bottom: 0, right: 16)
			return cell
		} else if indexPath.row == models.count + 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "pricesCell", for: indexPath) as! PricesCell
			return cell
		} else if indexPath.row == models.count + 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "callTaxiCell", for: indexPath) as! CallTaxiCell
			cell.callButton.setTitle("Поднять цену", for: .normal)
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
		if indexPath.row == 0 {
			return 33
		} else if indexPath.row > 0 && indexPath.row <= models.count {
			return 63
		} else if indexPath.row == models.count + 1 {
			return 41
		} else if indexPath.row == models.count + 2 {
			return 73
		} else if indexPath.row == models.count + 3 {
			return 45
		}
		return 0
	}
}
