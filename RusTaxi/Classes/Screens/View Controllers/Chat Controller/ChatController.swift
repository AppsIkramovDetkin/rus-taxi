//
//  ChatController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 15.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import ReverseExtension

class ChatController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sendButton: UIButton!
	
	var messages: [MessageModel] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	private var timer: TimerInteractor?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		customizeTextField()
		registerNibs()
		customizeBar()
		setNotifications()
		tableView.keyboardDismissMode = .onDrag
		loadData()
		timer = TimerInteractor()
		timer?.loop(on: Time(7.5), callback: {
			self.loadData()
		})
		sendButton.addTarget(self, action: #selector(sendButtonClicked(sender:)), for: .touchUpInside)
	}

	@objc private func sendButtonClicked(sender: UIButton) {
		guard let text = textField.text, !text.isEmpty else {
			return
		}
		let saverModel = StatusSaver.shared.retrieve()
		let orderId = saverModel?.local_id ?? ""
		let status = saverModel?.status ?? ""
		ChatManager.shared.sendMessageToDriver(orderId: orderId, order_status: status, message: text, with: {
			success in
			self.loadData()
		})
		textField.text = nil
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func loadData() {
		let saverModel = StatusSaver.shared.retrieve()
		let orderId = saverModel?.local_id ?? ""
		let status = saverModel?.status ?? ""
		ChatManager.shared.getAllMessages(orderId: orderId, order_status: status) { (messages) in
			self.messages = messages.reversed()	
		}
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
		tableView.re.delegate = self
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
		let message = messages[indexPath.row]
		let isSender = message.who ?? false
		let cell = tableView.dequeueReusableCell(withIdentifier: isSender ? "receiverCell" : "senderCell", for: indexPath) as! ChatCell
		cell.configure(by: message)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 78
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
}
