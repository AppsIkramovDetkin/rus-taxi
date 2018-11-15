//
//  ProfileController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import Alamofire

class ProfileController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var saveButton: UIButton!
	let picker = UIImagePickerController()
	fileprivate var profile: UserInfoModelResponse? = {
		return UserManager.shared.lastResponse
	}()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		customizeBar()
		picker.delegate = self
		picker.allowsEditing = true
		saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
		navigationController?.navigationBar.tintColor = .black
		UserManager.shared.loaded = {
			self.tableView.reloadData()
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
			return
		}
		print("HereImage: \(choosenImage)")
		dismiss(animated: true, completion: nil)
//		let req = A
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func saveButtonClicked() {
		if let profile = self.profile {
			UserManager.shared.applyInfo(with: profile)
		}
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
			cell.photoButtonClicked = {
				self.picker.allowsEditing = true
				if UIImagePickerController.isSourceTypeAvailable(.camera) {
					self.picker.sourceType = .camera
				} else {
					self.picker.sourceType = .photoLibrary
				}
				self.present(self.picker, animated: true, completion: nil)
			}
			cell.pictureButtonClicked = {
				self.picker.allowsEditing = false
				self.picker.sourceType = .photoLibrary
				self.present(self.picker, animated: true, completion: nil)
			}
			if let urlString = profile?.url_client, let url = URL(string: urlString) {
				cell.avatarImageView.af_setImage(withURL: url)
			}
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingsCell", for: indexPath) as! ProfileSettingsCell
			cell.textField.placeholder = Localize("name")
			cell.textField.text = profile?.i
			cell.textChanged = {
				text in
				self.profile?.i = text
			}
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldsCell", for: indexPath) as! TwoTextFieldsCell
			cell.firstTextField.placeholder = Localize("surname")
			cell.firstTextField.text = profile?.f
			cell.secondTextField.placeholder = Localize("patronymic")
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
			cell.textField.placeholder = Localize("mail")
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
			let secondPart = profile?.birthday?.split(separator: " ")[0] ?? ""
			
			let dateFormatter = DateFormatter.init()
			dateFormatter.dateFormat = "dd.MM.yyyy"
			let date = dateFormatter.date(from: String(secondPart))
			if let unboxDate = date {
				cell.datePicker.setDate(unboxDate, animated: true)
				cell.titleLabel.text = Localize("birthday")
				cell.datePicker.isHidden = false
			} else {
				cell.titleLabel.text = Localize("birthdayNotSelected")
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
