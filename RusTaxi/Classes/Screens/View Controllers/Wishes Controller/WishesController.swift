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
	@IBOutlet weak var doneButton: UIButton!
	
	private var wishes: [Equip] = {
		return MapDataProvider.shared.wishes
	}()
	private var selectedTariffs: [Tarif] = [] {
		didSet {
			
			NewOrderDataProvider.shared.set(wishes: selectedTariffs)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNib()
		customizeBar()
		changeSeparatorColor()
		addAction()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func addAction() {
		doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
	}
	
	@objc private func doneButtonClicked() {
		smartBack()
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
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! WishesCell
		cell.switcher.setOn(!cell.switcher.isOn, animated: true)
		cell.switchChanged?(cell.switcher.isOn)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "wishesCell", for: indexPath) as! WishesCell
		let wish = wishes[indexPath.row]
		cell.configure(by: wish)
		let isFavourite = NewOrderDataProvider.shared.request.requirements?.contains(where: { (requirement) -> Bool in
			return requirement.id == wish.id
		}) ?? false
		cell.switcher.setOn(isFavourite, animated: true)
		cell.switchChanged = { value in
			if let id = wish.id {
				let tarif = Tarif(uuid: id)
				
				let index = self.selectedTariffs.firstIndex(where: { (tarifModel) -> Bool in return tarif.uuid == tarifModel.uuid })
				if let int = index, !value {
					self.selectedTariffs.remove(at: int)
				} else {
					self.selectedTariffs.append(tarif)
				}
			}
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return wishes.count
	}
}
