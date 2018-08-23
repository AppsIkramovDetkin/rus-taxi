//
//  PresenterViewController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PresenterViewController: UIViewController, NibLoadable {

	@IBOutlet weak var tableView: UITableView!
	
	var completion: ((String, UIImage) -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		delegating()
		registerNib()
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func registerNib() {
		tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "countryCell")
	}
}

extension PresenterViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
		cell.countryLabel.text = countries[indexPath.row] + " " + numberCodes[indexPath.row]
		cell.countryImageView.image = flags[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		completion?(numberCodes[indexPath.row], flags[indexPath.row])
		smartBack()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
}
