//
//  SideMenuController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		tableView.separatorColor = TaxiColor.darkGray
		UserManager.shared.loaded = {
			self.tableView.reloadData()
		}
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 2: // profile
			self.show(ProfileController())
		case 4:
			CorporateClientAlert.shared.showPayAlert(in: self) { (login, password) in
				AuthManager.shared.authOrg(login: login, password: password, with: { (txt) in
					self.showAlertWithOneAction(title: "", message: txt, handle: {
						if !txt.contains("denied".localized) {
							UserManager.shared.getMyInfo(with: { callback in
								let tariffs = callback?.tariffs ?? []
								NewOrderDataProvider.shared.inject(tariffs: tariffs)
							})
						}
					})
				})
			}
		case 5:
			self.show(SettingsController())
		case 6:
			self.show(SupportChatController())
		case 7:
			let vc = SlideshowController()
			vc.isForDissmiss = true
			self.show(vc)
		case 8:
			self.show(AboutTaxiController())
		default: break
		}
	}
	
	private func show(_ vc: UIViewController) {
		SideMenuManager.default.menuLeftNavigationController?.pushViewController(vc, animated: true)
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
