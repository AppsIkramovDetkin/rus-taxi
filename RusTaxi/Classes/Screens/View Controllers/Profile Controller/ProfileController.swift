//
//  ProfileController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var saveButton: UIButton!
	
	fileprivate var profile: UserInfoModelResponse? = {
		return UserManager.shared.lastResponse
	}()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		customizeBar()
		saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
		navigationController?.navigationBar.tintColor = .black
		UserManager.shared.loaded = {
			self.tableView.reloadData()
		}
	}
	
	@objc private func saveButtonClicked() {
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func customizeBar() {
		self.title = "Профиль"
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "AvatarCell", bundle: nil), forCellReuseIdentifier: "avatarCell")
		tableView.register(UINib(nibName: "ProfileSettingsCell", bundle: nil), forCellReuseIdentifier: "profileSettingsCell")
		tableView.register(UINib(nibName: "TwoTextFieldsCell", bundle: nil), forCellReuseIdentifier: "textFieldsCell")
		tableView.register(UINib(nibName: "PhoneNumberCell", bundle: nil), forCellReuseIdentifier: "phoneCell")
		tableView.register(UINib(nibName: "SendingReceiptsCell", bundle: nil), forCellReuseIdentifier: "sendCell")
		tableView.register(UINib(nibName: "BirthdayCell", bundle: nil), forCellReuseIdentifier: "birthdayCell")
	}
	
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "avatarCell", for: indexPath) as! AvatarCell
			
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsCell", for: indexPath) as! ProfileSettingsCell
			cell.textField.placeholder = "ИМЯ"
			cell.textField.text = profile?.i
			cell.textChanged = {
				text in
				self.profile?.i = text
			}
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldsCell", for: indexPath) as! TwoTextFieldsCell
			cell.firstTextField.placeholder = "ФАМИЛИЯ"
			cell.firstTextField.text = profile?.f
			cell.secondTextField.placeholder = "ОТЧЕСТВО"
			cell.secondTextField.text = profile?.o
			cell.firstTextFieldChanged = {
				text in
				self.profile?.f = text
			}
			
			cell.secondTextFieldChanged = {
				text in
				self.profile?.o = text
			}
			return cell
		} else if indexPath.row == 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath) as! PhoneNumberCell
			cell.phoneTextField.text = profile?.phone
			cell.textChanged = {
				text in
				self.profile?.phone = text
			}
			return cell
		} else if indexPath.row == 4 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsCell", for: indexPath) as! ProfileSettingsCell
			cell.textChanged = {
				text in
				self.profile?.email = text
			}
			cell.textField.placeholder = "ЭЛ. ПОЧТА"
			cell.textField.text = profile?.email
			return cell
		} else if indexPath.row == 5 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! SendingReceiptsCell
			cell.checkChanged = {
				state in
				self.profile?.allow_email_notif = "\(state)"
			}
			return cell
		} else if indexPath.row == 6 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCell", for: indexPath) as! BirthdayCell
			let secondPart = profile?.birthday?.split(separator: " ")[1] ?? ""
			
			let dateFormatter = DateFormatter.init()
			dateFormatter.dateFormat = "HH:mm:ss"
			let date = dateFormatter.date(from: String(secondPart))
			if let unboxDate = date {
				cell.datePicker.setDate(unboxDate, animated: true)
				cell.titleLabel.text = "Дата рождения"
				cell.datePicker.isHidden = false
			} else {
				cell.titleLabel.text = "Дата не стоит"
				cell.datePicker.isHidden = true
			}
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 89
		} else if indexPath.row == 3 {
			return 40
		} else if indexPath.row == 5 {
			return 44
		} else if indexPath.row == 6 {
			return 149
		} else {
			return 35
		}
	}
}
