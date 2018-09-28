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
	var models: [ModelType] = []
	var scrollViewScrolled: ScrollViewClosure?
	var cellClicked: ItemClosure<ModelType>
	var editButtonClicked: ItemClosure<SearchAddressResponseModel>?
	
	required init(closure: @escaping ItemClosure<ModelType>) {
		self.models = AddressInteractor.shared.retrieve().sorted{$0.numberOfUses > $1.numberOfUses}.map{$0.entity}
		self.cellClicked = closure
	}
	
	func update(with models: [Any]) {
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prevCell", for: indexPath) as! PreviousAddressCell
		let model = models[indexPath.row]
		cell.verticalView.isHidden = false
		cell.editButton.isHidden = false
		cell.editButtonClicked = editButtonClicked
		cell.anotherLabel.isHidden = false
		cell.configure(by: model)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let model = models[indexPath.row]
		cellClicked(model)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 68
	}
}
