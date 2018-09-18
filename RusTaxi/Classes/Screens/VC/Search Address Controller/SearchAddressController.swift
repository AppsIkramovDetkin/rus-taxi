//
//  SearchAddressController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SearchAddressController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var applyButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		customizeBar()
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isScrollEnabled = false
	}
	
	private func customizeBar() {
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
		navigationController?.navigationBar.tintColor = TaxiColor.black
		self.title = "Откуда"
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "InputAddressCell", bundle: nil), forCellReuseIdentifier: "inputCell")
		tableView.register(UINib(nibName: "CommentAddressCell", bundle: nil), forCellReuseIdentifier: "commentCell")
		tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "labelCell")
		tableView.register(UINib(nibName: "PreviousAddressCell", bundle: nil), forCellReuseIdentifier: "prevCell")
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputAddressCell
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentAddressCell
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelCell
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "prevCell", for: indexPath) as! PreviousAddressCell
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 2 {
			return 25
		} else if indexPath.row == 1 || indexPath.row == 2{
			return 44
		} else {
			return 68
		}
	}
}
