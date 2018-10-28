//
//  SideMenuController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		tableView.separatorColor = TaxiColor.darkGray
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "HeadCell", bundle: nil), forCellReuseIdentifier: "headCell")
		tableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
	}
}

extension SideMenuController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeadCell
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! MenuItemCell
			cell.label.text = menuItems[indexPath.row - 1]
			cell.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count + 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 88
		} else {
			return 45
		}
	}
}
