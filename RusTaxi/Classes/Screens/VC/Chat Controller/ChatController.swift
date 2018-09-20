//
//  ChatController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 15.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sendButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		customizeTextField()
		registerNibs()
		customizeBar()
		setNotifications()
		tableView.keyboardDismissMode = .onDrag
	}
	
	private func setNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			self.view.frame.origin.y = -keyboardSize.height
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
	}
	
	private func customizeTextField() {
		textField.underline()
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "senderCell")
		tableView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "receiverCell")
	}
	
	private func delegating() {
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	private func customizeBar() {
		navigationController?.navigationBar.barTintColor = TaxiColor.orange
		navigationController?.navigationBar.tintColor = TaxiColor.black
		self.title = Localize("chat")
	}
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderCell
			cell.messageLabel.text = "Hi"
			cell.timeLabel.text = "14:02"
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as! ReceiverCell
			cell.messageLabel.text = "Добрый"
			cell.timeLabel.text = "14:02"
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 78
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
}
