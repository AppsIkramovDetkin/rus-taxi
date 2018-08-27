//
//  ViewController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 21.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import Material

class ViewController: UIViewController, NibLoadable, UITextFieldDelegate {
	@IBOutlet weak var tableView: UITableView!
	
	private let heightForHeader: CGFloat = 65
	//!! move to model
	private var numberCode: String = "+7"
	private var countryFlag: UIImage = #imageLiteral(resourceName: "ic_flag_russia")
	private var phone: String = ""
	private var name: String = ""
	private var receivedCode: String?
	private var enteredCode: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		customHeightForHeaderView()
		registerNibs()
		customizeBar()
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func customizeBar() {
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
		navigationController?.navigationBar.tintColor = TaxiColor.black
		self.title = Localize("order")
	}
	
	@objc private func countryButtonClicked(sender: UIButton) {
		let vc = PresenterViewController()
		vc.completion = { codeNumber, flagImage in
			self.numberCode = codeNumber
			self.countryFlag = flagImage
			self.tableView.reloadData()
		}
		navigationController?.pushViewController(vc, animated: true)
	}
	
	private func customHeightForHeaderView() {
		self.tableView.sectionHeaderHeight = heightForHeader
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "textFieldCell")
		tableView.register(UINib(nibName: "PhoneTextFieldCell", bundle: nil), forCellReuseIdentifier: "phoneTextFieldCell")
		tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
		tableView.register(UINib(nibName: "FooterButtonView", bundle: nil), forCellReuseIdentifier: "footerCell")
	}
	
	@objc func sendSms() {
		guard !phone.isEmpty, !numberCode.isEmpty, !name.isEmpty else {
			//!! move to localizes
			showAlert(title: "Ошибка", message: "Заполните необходимые поля.")
			return
		}
		let fullPhone = numberCode + phone
		AuthManager.shared.activateClientPhone(prefix: numberCode, phone: fullPhone, fio: name) { (error, code) in
			if let code = code {
				//!! Move to localizes
				print("code: \(code)")
				self.showAlert(title: "Успешно", message: "Код отправлен на ваш телефон, введите его в поле ниже: \(code)")
			}
			self.receivedCode = code
		}
	}
	
	@objc func login() {
		guard let receivedCode = receivedCode else {
			//!! move to localizes
			showAlert(title: "Ошибка", message: "Пройдите авторизацию.")
			return
		}
		
		if receivedCode == enteredCode {
			// success
			showAlertWithOneAction(title: "Успешно", message: "Авторизация успешно прошла!") {
				self.navigationController?.pushViewController(SlideshowController(), animated: true)
			}
		} else {
			// move to localizes
			showAlert(title: "Ошибка", message: "Код не совпадает с отправленным по смс.")
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
		switch textField.tag {
		case 5:
			return updatedText.count <= 11
		case 6:
			return updatedText.count <= 4
		default: return true
		}
	}
	@objc func phoneTextFieldChanged(sender: UITextField) {
		phone = sender.text ?? ""
		tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
	}
	
	@objc func nameTextFieldChanged(sender: UITextField) {
		name = sender.text ?? ""
		tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
	}
	
	var isCodeEnable: Bool {
		return phone.count >= 7 && phone.count <= 11 && !name.isEmpty
	}
	var isContinueEnable: Bool {
		return enteredCode.count == 4 && phone.count >= 7 && phone.count <= 11 && !name.isEmpty
	}
	
	@objc func codeTextFieldChanged(sender: UITextField) {
		enteredCode = sender.text ?? ""
		tableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
			cell.textField.placeholder = Localize("name")
			cell.textField.addTarget(self, action: #selector(nameTextFieldChanged(sender:)), for: .editingChanged)
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "phoneTextFieldCell", for: indexPath) as! PhoneTextFieldCell
			cell.phoneTextField.placeholder = Localize("phoneNumber")
			cell.phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged(sender:)), for: .editingChanged)
			cell.countryButton.setImage(countryFlag, for: .normal)
			cell.phoneLabel.text = numberCode
			cell.phoneTextField.tag = 5
			cell.phoneTextField.delegate = self
			cell.countryButton.addTarget(self, action: #selector(countryButtonClicked(sender:)), for: .touchUpInside)
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
			cell.textField.placeholder = Localize("enterCode")
			cell.textField.textAlignment = .center
			cell.textField.tag = 6
			cell.textField.delegate = self
			cell.textField.keyboardType = .numberPad
			cell.textField.addTarget(self, action: #selector(codeTextFieldChanged(sender:)), for: .editingChanged)
			return cell
		} else if indexPath.row == 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
			cell.sendButton.setTitle(Localize("getCode"), for: .normal)
			if isCodeEnable {
				cell.sendButton.isEnabled = true
				cell.sendButton.setTitleColor(.black, for: .normal)
			} else {
				cell.sendButton.isEnabled = false
				cell.sendButton.setTitleColor(.darkGray, for: .normal)
			}
			cell.sendButton.addTarget(self, action: #selector(sendSms), for: .touchUpInside)
			return cell
		} else if indexPath.row == 4 {
			let cell = UITableViewCell()
			cell.selectionStyle = .none
			return cell
		} else if indexPath.row == 5 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell", for: indexPath) as! FooterButtonView
			cell.continueButton.addTarget(self, action: #selector(login), for: .touchUpInside)
			cell.selectionStyle = .none
			cell.continueButton.setTitle(Localize("continueButton"), for: .normal)
			if isContinueEnable {
				cell.continueButton.isEnabled = true
				cell.continueButton.setTitleColor(.black, for: .normal)
			} else {
				cell.continueButton.isEnabled = false
				cell.continueButton.setTitleColor(UIColor.darkGray, for: .normal)
			}
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! HeaderView
		header.label.text = Localize("headerLabel")
		self.tableView.tableHeaderView = header
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 4 {
			return 132
		} else if indexPath.row == 5 {
			return 112
		} else {
			return 60
		}
	}
}
