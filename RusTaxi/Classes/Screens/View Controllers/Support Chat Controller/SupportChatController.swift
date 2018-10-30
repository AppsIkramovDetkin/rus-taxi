//
//  Support Chat Controller.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 28.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SupportChatController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sendView: UIView!
	@IBOutlet weak var sendButton: UIButton!
	
	private var messages: [MessageModel] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		customizeSendView()
		textField.underline()
		ChatManager.shared.feedBackGetMsgClient { (messages) in
			self.messages = messages.reversed()
		}
		sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
	}
	
	@objc private func sendButtonClicked() {
		guard let text = textField.text, !text.isEmpty else {
			return
		}
		ChatManager.shared.feedBackAddMsgClient(msg: text) { (messages) in
			self.textField.text = nil
			self.messages = messages.reversed()
		}
	}
	
	private func customizeSendView() {
		sendView.layer.cornerRadius = sendView.frame.size.width / 2
		sendView.clipsToBounds = true
		
		sendView.layer.borderColor = TaxiColor.orange.cgColor
		sendView.layer.borderWidth = 1
	}
	
	private func delegating() {
		tableView.re.delegate = self
		tableView.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NavigationBarDecorator.decorate(self)
		title = Localize("feedBack")
		navigationController?.navigationBar.tintColor = .black
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "senderCell")
		tableView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "receiverCell")
	}
}

extension SupportChatController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = messages[indexPath.row]
		let isSender = message.who ?? false
		let cell = tableView.dequeueReusableCell(withIdentifier: isSender ? "receiverCell" : "senderCell", for: indexPath) as! ChatCell
		cell.configure(by: message)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 78
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
