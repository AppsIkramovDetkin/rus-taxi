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
	
	func update(with models: [Any]) {
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "prevCell", for: indexPath) as! PreviousAddressCell
		cell.verticalView.isHidden = true
		cell.editButton.isHidden = true
		cell.anotherLabel.isHidden = true
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 68
	}
}
