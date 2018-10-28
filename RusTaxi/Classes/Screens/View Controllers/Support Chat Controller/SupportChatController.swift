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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegating()
		registerNibs()
		customizeSendView()
		textField.underline()
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
		title = "Обратная связь"
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
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! ChatCell
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as! ChatCell
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 78
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
