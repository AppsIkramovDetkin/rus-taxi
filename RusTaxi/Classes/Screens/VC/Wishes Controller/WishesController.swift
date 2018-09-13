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
		if indexPath.row == 5 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "wishesCell", for: indexPath) as! WishesCell
			cell.priceLabel.isHidden = false
			cell.label.text = wishes[5]
			cell.priceLabel.text = wishesPrice[0]
			return cell
		} else if indexPath.row == 8 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "wishesCell", for: indexPath) as! WishesCell
			cell.label.text = wishes[indexPath.row]
			cell.priceLabel.isHidden = false
			cell.priceLabel.text = wishesPrice[1]
			cell.label.text = wishes[8]
			return cell
		} else if indexPath.row == 9 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "wishesCell", for: indexPath) as! WishesCell
			cell.label.text = wishes[indexPath.row]
			cell.priceLabel.isHidden = false
			cell.priceLabel.text = wishesPrice[2]
			cell.label.text = wishes[9]
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "wishesCell", for: indexPath) as! WishesCell
			cell.label.text = wishes[indexPath.row]
			cell.priceLabel.isHidden = true
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return wishes.count
	}
}
