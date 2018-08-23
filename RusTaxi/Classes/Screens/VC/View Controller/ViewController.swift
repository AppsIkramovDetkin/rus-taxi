//
//  ViewController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 21.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import Material

class ViewController: UIViewController, NibLoadable {
	@IBOutlet weak var tableView: UITableView!
	
	private let heightForHeader: CGFloat = 140
	private let heightForFooter: CGFloat = 112
	var numberCode: String = "+7"
	var countryFlag: UIImage = #imageLiteral(resourceName: "ic_flag_russia")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		customHeightForHeaderAndFooterView()
		registerNibs()
		createNavBar()
	}

	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func createNavBar() {
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
		self.title = Localize("order")
	}
	
	@objc private func countryButtonClicked(sender: UIButton) {
		let vc = PresenterViewController()
		vc.completion = { codeNumber, flagImage in
			self.numberCode = codeNumber
			self.countryFlag = flagImage
			self.tableView.reloadData()
		}
		self.present(vc, animated: true, completion: nil)
	}
	
	private func customHeightForHeaderAndFooterView() {
		self.tableView.sectionHeaderHeight = heightForHeader
		self.tableView.sectionFooterHeight = heightForFooter
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "textFieldCell")
		tableView.register(UINib(nibName: "PhoneTextFieldCell", bundle: nil), forCellReuseIdentifier: "phoneTextFieldCell")
		tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
			cell.textField.placeholder = Localize("name")
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "phoneTextFieldCell", for: indexPath) as! PhoneTextFieldCell
			cell.phoneTextField.placeholder = Localize("phoneNumber")
			cell.countryButton.setImage(countryFlag, for: .normal)
			cell.phoneLabel.text = numberCode
			cell.countryButton.addTarget(self, action: #selector(countryButtonClicked(sender:)), for: .touchUpInside)
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
			cell.textField.placeholder = Localize("enterCode")
			cell.textField.textAlignment = .center
			return cell
		} else if indexPath.row == 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
			cell.sendButton.setTitle(Localize("getCode"), for: .normal)
			return cell
		} else if indexPath.row == 4 {
			let cell = UITableViewCell()
			cell.selectionStyle = .none
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! HeaderView
		header.label.text = Localize("headerLabel")
		return header
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footer = Bundle.main.loadNibNamed("FooterButtonView", owner: self, options: nil)![0] as! FooterButtonView
		footer.continueButton.setTitle(Localize("continueButton"), for: .normal)
		return footer
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 3 {
			return 60
		} else if indexPath.row == 4 {
			return 240
		} else {
			return 60
		}
	}
}
