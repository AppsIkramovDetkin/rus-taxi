//
//  AddCardController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12/11/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AddCardController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
}

extension AddCardController: UITableViewDelegate, UITableViewDataSource {
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
