//
//  PayCardController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12/11/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PayCardController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addCardButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		customizeBar()
		addAction()
	}
	
	private func addAction() {
		addCardButton.addTarget(self, action: #selector(addCardButtonClicked(sender:)), for: .touchUpInside)
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	@objc private func addCardButtonClicked(sender: UIButton) {
		let vc = AddCardController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	private func customizeBar() {
		self.title = "Оплата"
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
	}
}

extension PayCardController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = "Test"
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 44
	}
}
