//
//  PreviousAddressDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 18.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PreviousAddressDataSource: NSObject, MainDataSource {
	typealias ModelType = SearchAddressResponseModel
	private var models: [ModelType] = []
	var scrollViewScrolled: ScrollViewClosure?
	
	func update(with models: [Any]) {
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prevCell", for: indexPath) as! PreviousAddressCell
		let model = models[indexPath.row]
		cell.configure(by: model)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 68
	}
}
