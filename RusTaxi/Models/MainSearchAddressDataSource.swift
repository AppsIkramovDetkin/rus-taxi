//
//  MainSearchAddressDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 18.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class MainSearchAddressDataSource: NSObject, MainDataSource {
	var scrollViewScrolled: ScrollViewClosure?
	var models: [SearchAddressResponseModel] = []
	
	func update(with models: [Any]) {
		
	}
	
	required init(closure: @escaping ItemClosure<SearchAddressResponseModel>) {
		self.cellSelected = closure
	}
	
	var cellSelected: ItemClosure<SearchAddressResponseModel>
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prevCell", for: indexPath) as! PreviousAddressCell
		cell.verticalView.isHidden = true
		cell.editButton.isHidden = true
		cell.anotherLabel.isHidden = true
		let model = models[indexPath.row]
		cell.configure(by: model)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let model = models[indexPath.row]
		var newModels = Storage.shared.savedAddressResponseModels()
		let ids = newModels.map{$0.FullName}
		if !ids.contains(model.FullName) {
			newModels.insert(model, at: 0)
			Storage.shared.save(addressResponseModels: newModels)
		}
		cellSelected(model)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return models.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 68
	}
}
