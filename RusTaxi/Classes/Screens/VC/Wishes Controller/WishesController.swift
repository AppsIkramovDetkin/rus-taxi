//
//  WishesController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 13.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class WishesController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNib()
		customizeBar()
		changeSeparatorColor()
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func registerNib() {
		tableView.register(UINib(nibName: "WishesCell", bundle: nil), forCellReuseIdentifier: "wishesCell")
	}
	
	private func changeSeparatorColor() {
		tableView.separatorColor = TaxiColor.darkGray
	}
	
	private func customizeBar() {
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
		navigationController?.navigationBar.tintColor = TaxiColor.black
		self.title = Localize("wishes")
	}
}

extension WishesController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "wishesCell", for: indexPath) as! WishesCell
		cell.configure(by: wishes[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return wishes.count
	}
}
